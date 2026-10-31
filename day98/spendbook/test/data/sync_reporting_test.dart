import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendbook/data/local/app_database.dart';
import 'package:spendbook/data/local/sync_local_data_source.dart';
import 'package:spendbook/data/remote/firestore_expense_remote.dart';
import 'package:spendbook/data/sync/firestore_sync_repository.dart';
import 'package:spendbook/domain/repositories/error_reporter.dart';

class MockRemote extends Mock implements FirestoreExpenseRemote {}

class FakeReporter implements ErrorReporter {
  final reported = <(Object, String)>[];

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    required String reason,
  }) async => reported.add((error, reason));
}

/// Day 95: which sync failures a developer hears about.
void main() {
  late AppDatabase db;
  late MockRemote remote;
  late FakeReporter reporter;
  late FirestoreSyncRepository sync;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    remote = MockRemote();
    reporter = FakeReporter();
    sync = FirestoreSyncRepository(
      SyncLocalDataSource(db),
      remote,
      reporter: reporter,
    );
  });
  tearDown(() => db.close());

  void failWith(String code) =>
      when(() => remote.changesSince(any(), any()))
          .thenThrow(FirebaseException(plugin: 'cloud_firestore', code: code));

  test('offline: expected, not reported', () async {
    failWith('unavailable');

    final result = await sync.sync('u1');

    expect(result.isLeft(), isTrue);
    expect(reporter.reported, isEmpty);
  });

  test('anything else from Firestore: reported as "sync"', () async {
    failWith('permission-denied');

    final result = await sync.sync('u1');

    expect(result.isLeft(), isTrue); // the user still sees a message
    expect(reporter.reported, hasLength(1));
    final (error, reason) = reporter.reported.single;
    expect((error as FirebaseException).code, 'permission-denied');
    expect(reason, 'sync');
  });

  test("any other error: only its type, never what's in it", () async {
    when(() => remote.changesSince(any(), any()))
        .thenThrow(_DatabaseError('INSERT ... VALUES (Lunch, 1250)'));

    final result = await sync.sync('u1');

    expect(result.isLeft(), isTrue);
    final (error, reason) = reporter.reported.single;
    expect(error.toString(), isNot(contains('Lunch')));
    expect(error.toString(), contains('_DatabaseError'));
    expect(reason, 'sync');
  });
}

/// Like a database error whose message has an expense's values in it.
class _DatabaseError implements Exception {
  _DatabaseError(this.message);

  final String message;

  @override
  String toString() => message;
}
