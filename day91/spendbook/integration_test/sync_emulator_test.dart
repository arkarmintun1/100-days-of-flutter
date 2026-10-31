import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:spendbook/data/local/app_database.dart';
import 'package:spendbook/data/local/expense_local_data_source.dart';
import 'package:spendbook/data/local/sync_local_data_source.dart';
import 'package:spendbook/data/models/expense_mapper.dart';
import 'package:spendbook/data/remote/firestore_expense_remote.dart';
import 'package:spendbook/data/sync/firestore_sync_repository.dart';
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/entities/expense_category.dart';

/// Day 91: two "phones" (two Drift databases) syncing through the
/// Firestore emulator, signed in with the Auth emulator:
///
///   firebase emulators:exec --only auth,firestore --project demo-spendbook \
///     "fvm flutter test integration_test/sync_emulator_test.dart -d DEVICE_ID"
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // Two phones = two separate in-memory databases, on purpose.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets('two phones of one account stay the same', (_) async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        // Not a real key, but in the shape iOS checks for (Day 90).
        apiKey: 'AIzaSyDemo0nlyForTheAuthEmulator0000000',
        appId: '1:1234567890:ios:0123456789abcdef',
        messagingSenderId: '1234567890',
        projectId: 'demo-spendbook',
      ),
    );
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    final firestore = FirebaseFirestore.instance
      ..settings = const Settings(persistenceEnabled: false)
      ..useFirestoreEmulator('localhost', 8080);
    final user = (await FirebaseAuth.instance.signInAnonymously()).user!;

    final phoneA = AppDatabase(NativeDatabase.memory());
    final phoneB = AppDatabase(NativeDatabase.memory());
    addTearDown(phoneA.close);
    addTearDown(phoneB.close);
    FirestoreSyncRepository sync(AppDatabase db) => FirestoreSyncRepository(
      SyncLocalDataSource(db),
      FirestoreExpenseRemote(firestore),
    );
    Future<List<String>> titles(AppDatabase db) async => [
      for (final row in await ExpenseLocalDataSource(db).watchAll().first)
        row.title,
    ];

    // Phone A adds an expense and syncs; phone B syncs and has it.
    await ExpenseLocalDataSource(phoneA).insert(
      Expense(
        id: 'lunch-${DateTime.now().microsecondsSinceEpoch}',
        title: 'Lunch',
        amountCents: 1250,
        category: ExpenseCategory.food,
        date: DateTime(2026, 10, 28, 12),
      ).toRow(),
    );
    final up = await sync(phoneA).sync(user.uid);
    expect(up.getRight().toNullable()!.uploaded, 1);
    await sync(phoneB).sync(user.uid);
    expect(await titles(phoneB), ['Lunch']);

    // Firestore set its own time on the document.
    final docs = await firestore.collection('users/${user.uid}/expenses').get();
    expect(docs.docs.single.data()['syncedAt'], isA<Timestamp>());

    // Phone B deletes it; after syncing, phone A doesn't show it either.
    final id = docs.docs.single.id;
    await ExpenseLocalDataSource(phoneB).delete(id);
    await sync(phoneB).sync(user.uid);
    await sync(phoneA).sync(user.uid);
    expect(await titles(phoneA), isEmpty);
  });
}
