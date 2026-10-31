import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/data/local/app_database.dart';
import 'package:spendbook/data/local/expense_local_data_source.dart';
import 'package:spendbook/data/models/expense_mapper.dart';
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/entities/expense_category.dart';

void main() {
  late AppDatabase db;
  late ExpenseLocalDataSource source;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    source = ExpenseLocalDataSource(db);
  });
  tearDown(() => db.close());

  Expense expense(String id, DateTime date, {String? note}) => Expense(
    id: id,
    title: 'Expense $id',
    amountCents: 1250,
    category: ExpenseCategory.food,
    date: date,
    note: note,
  );

  test('a saved expense comes back the same', () async {
    final lunch = expense('1', DateTime(2026, 10, 28, 12, 30), note: 'Noodles');
    await source.insert(lunch.toRow());

    final rows = await source.watchAll().first;
    expect(rows.map((row) => row.toEntity()), [lunch]);
  });

  test('an expense paid in another currency keeps it', () async {
    final noodles = expense('1', DateTime(2026, 10, 28)).copyWith(
      amountCents: 1249,
      original: const ForeignAmount(
        currency: 'SGD',
        minorUnits: 1600,
        decimalDigits: 2,
      ),
    );
    await source.insert(noodles.toRow());

    final rows = await source.watchAll().first;
    expect(rows.single.toEntity(), noodles);
  });

  test('newest first', () async {
    await source.insert(expense('old', DateTime(2026, 10, 1)).toRow());
    await source.insert(expense('new', DateTime(2026, 10, 28)).toRow());
    await source.insert(expense('mid', DateTime(2026, 10, 15)).toRow());

    final rows = await source.watchAll().first;
    expect(rows.map((row) => row.id), ['new', 'mid', 'old']);
  });

  test('watching sees inserts and deletes', () async {
    final counts = source
        .watchAll()
        .map((rows) => rows.length)
        .take(3)
        .toList();

    await pumpEventQueue();
    await source.insert(expense('1', DateTime(2026, 10, 28)).toRow());
    await pumpEventQueue();
    expect(await source.delete('1'), 1);

    expect(await counts, [0, 1, 0]);
  });

  test('Day 91: a deleted expense stays as a hidden tombstone', () async {
    await source.insert(expense('1', DateTime(2026, 10, 28)).toRow());

    expect(await source.delete('1'), 1);
    expect(await source.delete('1'), 0); // already deleted

    expect(await source.watchAll().first, isEmpty);
    final row = await db.select(db.expenses).getSingle();
    expect(row.deleted, isTrue);
    expect(row.dirty, isTrue); // the deletion is waiting for an upload
  });

  test('deleting an unknown id deletes nothing', () async {
    expect(await source.delete('nope'), 0);
  });

  test('the category is stored as its name', () async {
    await source.insert(expense('1', DateTime(2026, 10, 28)).toRow());

    final row = await db
        .customSelect('SELECT category FROM expenses')
        .getSingle();
    expect(row.read<String>('category'), 'food');
  });

  test('the same id twice is an error', () async {
    await source.insert(expense('1', DateTime(2026, 10, 28)).toRow());

    expect(
      source.insert(expense('1', DateTime(2026, 10, 28)).toRow()),
      throwsA(anything),
    );
  });

  test('a 60-emoji title fits (the domain checks the length)', () async {
    final row = expense('1', DateTime(2026, 10, 28)).copyWith(title: '👍' * 60);
    await source.insert(row.toRow());

    final rows = await source.watchAll().first;
    expect(rows.single.title, '👍' * 60);
  });
}
