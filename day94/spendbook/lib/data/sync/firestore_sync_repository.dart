import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/failures.dart';
import '../../domain/repositories/sync_repository.dart';
import '../local/app_database.dart';
import '../local/sync_local_data_source.dart';
import '../remote/firestore_expense_remote.dart';

/// Day 91: Drift stays the source of truth (the app reads only Drift);
/// Firestore is where the phones of one account meet.
class FirestoreSyncRepository implements SyncRepository {
  FirestoreSyncRepository(
    this._local,
    this._remote, {
    this.timeout = const Duration(seconds: 15),
  });

  final SyncLocalDataSource _local;
  final FirestoreExpenseRemote _remote;

  /// Offline, a write may wait for the network for as long as it takes.
  /// After a timeout, the SDK may still send it later: the rows stay dirty
  /// and go up again, which writes the same document again.
  final Duration timeout;

  /// One sync at a time: a second call waits for the running one.
  Future<Either<Failure, SyncReport>>? _running;

  @override
  Future<Either<Failure, SyncReport>> sync(String userId) async {
    while (_running != null) {
      await _running;
    }
    final run = _sync(userId);
    _running = run;
    try {
      return await run;
    } finally {
      _running = null;
    }
  }

  Future<Either<Failure, SyncReport>> _sync(String userId) async {
    try {
      var info = await _local.syncInfo();
      if (info?.userId != userId) {
        // First sync, or another account on this phone (a guest who signed
        // in to an account they already had): this phone's expenses go to
        // that account, and everything of it comes down.
        await _local.startSyncFor(userId);
        info = await _local.syncInfo();
      }

      // 1. Down first: a deletion from another phone arrives before we
      // upload, so we never send up an expense that was deleted there.
      final since = switch (info?.pulledUpTo) {
        final micros? => Timestamp.fromMicrosecondsSinceEpoch(micros),
        null => null,
      };
      final changes = await _remote
          .changesSince(userId, since)
          .timeout(timeout);
      await _local.applyRemote(changes.rows);
      await _local.saveSyncInfo(
        userId: userId,
        pulledUpTo: changes.upTo?.microsecondsSinceEpoch,
      );

      // 2. Up: this phone's changes (our own come down again next time;
      // applying them changes nothing).
      final dirty = await _local.dirtyRows();
      try {
        await _remote.upload(userId, dirty).timeout(timeout);
        await _local.markClean(dirty);
      } on FirebaseException catch (e) {
        if (e.code != 'permission-denied') rethrow;
        // Day 92: the rules turned the batch down. Find out which one.
        await _uploadOneByOne(userId, dirty);
      }
      return right(
        SyncReport(uploaded: dirty.length, downloaded: changes.rows.length),
      );
    } on TimeoutException {
      return left(const NetworkFailure('No connection. Syncing later.'));
    } on FirebaseException catch (e, stackTrace) {
      log('Sync failed', error: e, stackTrace: stackTrace);
      return left(switch (e.code) {
        'unavailable' => const NetworkFailure('No connection. Syncing later.'),
        'permission-denied' || 'unauthenticated' => const AuthFailure(
          'Sign in again to sync your expenses.',
        ),
        _ => const NetworkFailure("Couldn't sync. Trying again later."),
      });
    } on Object catch (e, stackTrace) {
      // Drift: the database on this phone.
      log('Sync failed', error: e, stackTrace: stackTrace);
      return left(const StorageFailure("Couldn't sync your expenses."));
    }
  }

  /// Day 92: an expense deleted on another phone between our download and
  /// our upload can't be sent back up (the rules keep tombstones final).
  /// Take the server's tombstone instead; anything else is a real error.
  Future<void> _uploadOneByOne(String userId, List<ExpenseRow> rows) async {
    for (final row in rows) {
      try {
        await _remote.upload(userId, [row]).timeout(timeout);
        await _local.markClean([row]);
      } on FirebaseException catch (e) {
        if (e.code != 'permission-denied') rethrow;
        final theirs = await _remote.fetch(userId, row.id).timeout(timeout);
        if (theirs == null || !theirs.deleted) rethrow;
        await _local.applyRemote([theirs]);
      }
    }
  }

  @override
  Stream<int> watchPendingChanges() => _local.watchDirtyCount();

  @override
  Future<Either<Failure, Unit>> clearLocal() async {
    try {
      await _local.clear();
      return right(unit);
    } on Object catch (e, stackTrace) {
      log('Clear failed', error: e, stackTrace: stackTrace);
      return left(const StorageFailure("Couldn't clear this phone's data."));
    }
  }
}
