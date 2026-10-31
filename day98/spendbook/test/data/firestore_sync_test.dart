import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/data/local/app_database.dart';
import 'package:spendbook/data/local/expense_local_data_source.dart';
import 'package:spendbook/data/local/sync_local_data_source.dart';
import 'package:spendbook/data/models/expense_firestore.dart';
import 'package:spendbook/data/models/expense_mapper.dart';
import 'package:spendbook/data/remote/firestore_expense_remote.dart';
import 'package:spendbook/data/sync/firestore_sync_repository.dart';
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/entities/expense_category.dart';

/// One phone: its own Drift database, the same Firestore as the others.
class Phone {
  Phone(FakeFirebaseFirestore cloud, {required this.now})
    : db = AppDatabase(NativeDatabase.memory()) {
    expenses = ExpenseLocalDataSource(db, now: () => now);
    sync = FirestoreSyncRepository(
      SyncLocalDataSource(db),
      FirestoreExpenseRemote(cloud),
    );
  }

  final AppDatabase db;
  late final ExpenseLocalDataSource expenses;
  late final FirestoreSyncRepository sync;

  /// This phone's clock.
  DateTime now;

  Future<List<String>> titles() async => [
    for (final row in await expenses.watchAll().first) row.title,
  ];
}

void main() {
  // Two phones = two separate in-memory databases, on purpose.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late FakeFirebaseFirestore cloud;
  late Phone a;
  late Phone b;

  setUp(() {
    cloud = FakeFirebaseFirestore();
    a = Phone(cloud, now: DateTime(2026, 10, 28, 9));
    b = Phone(cloud, now: DateTime(2026, 10, 28, 9));
  });
  tearDown(() async {
    await a.db.close();
    await b.db.close();
  });

  Expense expense(String id, String title) => Expense(
    id: id,
    title: title,
    amountCents: 1250,
    category: ExpenseCategory.food,
    date: DateTime(2026, 10, 28),
  );

  test('an expense added on one phone reaches the other', () async {
    await a.expenses.insert(expense('1', 'Lunch').toRow());

    final up = await a.sync.sync('u1');
    final down = await b.sync.sync('u1');

    expect(up.getRight().toNullable()!.uploaded, 1);
    expect(down.getRight().toNullable()!.downloaded, 1);
    expect(await b.titles(), ['Lunch']);
  });

  test('stored in users/{uid}/expenses, with the expense id', () async {
    await a.expenses.insert(expense('1', 'Lunch').toRow());
    await a.sync.sync('u1');

    final doc = await cloud.doc('users/u1/expenses/1').get();
    expect(doc.data()!['title'], 'Lunch');
    expect(doc.data()!['deleted'], isFalse);
  });

  test('a deletion travels as a tombstone', () async {
    await a.expenses.insert(expense('1', 'Lunch').toRow());
    await a.sync.sync('u1');
    await b.sync.sync('u1');

    b.now = DateTime(2026, 10, 28, 10);
    await b.expenses.delete('1');
    await b.sync.sync('u1');
    await a.sync.sync('u1');

    expect(await a.titles(), isEmpty);
    final doc = await cloud.doc('users/u1/expenses/1').get();
    expect(doc.data()!['deleted'], isTrue); // kept, so others see it
  });

  test('a deletion is final, whatever the clocks say', () async {
    // Phone A's clock is 10 minutes fast.
    a.now = DateTime(2026, 10, 28, 10, 10);
    await a.expenses.insert(expense('1', 'Lunch').toRow());
    await a.sync.sync('u1');
    await b.sync.sync('u1');

    // Phone B deletes it at 10:05: "earlier" than A's 10:10.
    b.now = DateTime(2026, 10, 28, 10, 5);
    await b.expenses.delete('1');
    await b.sync.sync('u1');
    await a.sync.sync('u1');

    expect(await a.titles(), isEmpty);
  });

  test("a repeated upload doesn't bring a deleted expense back", () async {
    await a.expenses.insert(expense('1', 'Lunch').toRow());
    await a.sync.sync('u1');
    // As if A's upload landed but A never heard back (a timeout): the row
    // is still dirty on A.
    await (a.db.update(a.db.expenses))
        .write(const ExpensesCompanion(dirty: Value(true)));

    await b.sync.sync('u1');
    await b.expenses.delete('1');
    await b.sync.sync('u1');
    await a.sync.sync('u1'); // downloads first, so it sees the deletion

    expect(await a.titles(), isEmpty);
    final doc = await cloud.doc('users/u1/expenses/1').get();
    expect(doc.data()!['deleted'], isTrue);
  });

  test('a document this app version can\'t read is asked for again', () async {
    final unknown = expense('1', 'Train').toRow().toFirestore()
      ..['category'] = 'travel'; // from a newer version of the app
    await cloud.doc('users/u1/expenses/1').set(unknown);

    await b.sync.sync('u1');
    expect(await b.titles(), isEmpty); // skipped, not a crash

    // "Updated app": now the document is one it understands.
    await cloud.doc('users/u1/expenses/1').update({'category': 'transport'});
    await b.sync.sync('u1');
    expect(await b.titles(), ['Train']);
  });

  test('nothing new: nothing comes down twice', () async {
    await a.expenses.insert(expense('1', 'Lunch').toRow());
    await a.sync.sync('u1');
    await b.sync.sync('u1');

    final again = await b.sync.sync('u1');

    // ">=" gets the last document again; applying it changes nothing.
    expect(again.getRight().toNullable()!.uploaded, 0);
    expect(await b.titles(), ['Lunch']);
  });

  test("a guest's expenses go to the account they sign in to", () async {
    await a.expenses.insert(expense('1', 'Lunch').toRow());
    await a.sync.sync('guest-1');

    final result = await a.sync.sync('account-1');

    expect(result.getRight().toNullable()!.uploaded, 1);
    final doc = await cloud.doc('users/account-1/expenses/1').get();
    expect(doc.exists, isTrue);
  });

  test('after signing out, the phone forgets the expenses', () async {
    await a.expenses.insert(expense('1', 'Lunch').toRow());
    await a.sync.sync('u1');

    await a.db
        .into(a.db.budgets)
        .insert(const BudgetRow(id: 1, monthlyCents: 50000));
    await a.sync.clearLocal();

    expect(await a.titles(), isEmpty);
    expect(await a.db.select(a.db.budgets).get(), isEmpty);
    expect((await cloud.doc('users/u1/expenses/1').get()).exists, isTrue);
    // The next account starts from what's in the cloud for it.
    await a.sync.sync('u1');
    expect(await a.titles(), ['Lunch']);
  });

  test('pending changes are counted until they are uploaded', () async {
    final counts = a.sync.watchPendingChanges().take(3).toList();
    await pumpEventQueue();
    await a.expenses.insert(expense('1', 'Lunch').toRow());
    await pumpEventQueue();
    await a.sync.sync('u1');

    expect(await counts, [0, 1, 0]);
  });
}
