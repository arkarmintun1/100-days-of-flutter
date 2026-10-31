import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendbook/data/local/app_database.dart';
import 'package:spendbook/data/local/expense_local_data_source.dart';
import 'package:spendbook/data/local/sync_local_data_source.dart';
import 'package:spendbook/data/models/expense_mapper.dart';
import 'package:spendbook/data/remote/firestore_expense_remote.dart';
import 'package:spendbook/data/sync/firestore_sync_repository.dart';
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/failures.dart';

class MockRemote extends Mock implements FirestoreExpenseRemote {}

/// Day 92: what the sync does when the rules say no.
void main() {
  late AppDatabase db;
  late MockRemote remote;
  late FirestoreSyncRepository sync;
  final denied = FirebaseException(
    plugin: 'cloud_firestore',
    code: 'permission-denied',
  );

  ExpenseRow row(String id) => Expense(
    id: id,
    title: id,
    amountCents: 100,
    category: ExpenseCategory.food,
    date: DateTime(2026, 10, 28),
  ).toRow();

  setUpAll(() => registerFallbackValue(<ExpenseRow>[]));
  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    remote = MockRemote();
    sync = FirestoreSyncRepository(SyncLocalDataSource(db), remote);
    when(() => remote.changesSince(any(), any()))
        .thenAnswer((_) async => const RemoteChanges([], null));
    await ExpenseLocalDataSource(db).insert(row('kept'));
    await ExpenseLocalDataSource(db).insert(row('gone'));
  });
  tearDown(() => db.close());

  Future<List<String>> ids() async => [
    for (final r in await ExpenseLocalDataSource(db).watchAll().first) r.id,
  ];

  test(
    'deleted on another phone: take its tombstone, upload the rest',
    () async {
      when(() => remote.upload(any(), any())).thenAnswer((call) async {
        final rows = call.positionalArguments[1] as List<ExpenseRow>;
        if (rows.any((r) => r.id == 'gone')) throw denied;
      });
      when(() => remote.fetch('u1', 'gone')).thenAnswer(
        (_) async => row('gone').copyWith(deleted: true, dirty: false),
      );

      final result = await sync.sync('u1');

      expect(result.isRight(), isTrue);
      expect(await ids(), ['kept']);
      expect(await sync.watchPendingChanges().first, 0);
    },
  );

  test(
    'turned down for another reason: an error, nothing marked done',
    () async {
      when(() => remote.upload(any(), any())).thenThrow(denied);
      when(() => remote.fetch(any(), any())).thenAnswer((_) async => null);

      final result = await sync.sync('u1');

      expect(result.getLeft().toNullable(), isA<AuthFailure>());
      expect(await sync.watchPendingChanges().first, 2);
    },
  );
}
