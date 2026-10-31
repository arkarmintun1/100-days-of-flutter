import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fpdart/fpdart.dart' show Left, Right;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/local/sync_local_data_source.dart';
import '../../data/remote/firestore_expense_remote.dart';
import '../../data/sync/firestore_sync_repository.dart';
import '../../domain/repositories/sync_repository.dart';
import '../../domain/usecases/sign_out.dart';
import 'auth.dart';
import 'dependencies.dart';
import 'monitoring.dart';

part 'sync.freezed.dart';
part 'sync.g.dart';

/// Null when Firebase isn't set up. Tests put a fake here.
@Riverpod(keepAlive: true)
SyncRepository? syncRepository(Ref ref) => ref.watch(firebaseReadyProvider)
    ? FirestoreSyncRepository(
        SyncLocalDataSource(ref.watch(appDatabaseProvider)),
        FirestoreExpenseRemote(FirebaseFirestore.instance),
        reporter: ref.watch(errorReporterProvider),
      )
    : null;

@riverpod
SignOut? signOut(Ref ref) => switch ((
  ref.watch(authRepositoryProvider),
  ref.watch(syncRepositoryProvider),
)) {
  (final auth?, final sync?) => SignOut(auth, sync),
  _ => null,
};

/// What the account screen shows about syncing.
@freezed
class const SyncState({
  /// False without Firebase or without a signed-in user.
  final bool active = false,
  final bool syncing = false,

  /// Changes on this phone that aren't uploaded yet.
  final int pending = 0,
  final DateTime? lastSynced,
  final String? error,
}) with _$SyncState;

/// Day 91: syncs when someone signs in, and a moment after every change on
/// this phone. Drift stays the source of truth: the screens never wait for
/// this.
@Riverpod(keepAlive: true)
class Sync extends _$Sync {
  /// Several quick changes (e.g. three expenses in a row) make one sync.
  static const delay = Duration(seconds: 2);

  /// After a failure (often: no connection), try again this much later.
  static const retryAfter = Duration(minutes: 1);

  Timer? _timer;

  @override
  SyncState build() {
    final repository = ref.watch(syncRepositoryProvider);
    final userId = ref.watch(currentUserIdProvider);
    if (repository == null || userId == null) return const SyncState();

    final pending = repository.watchPendingChanges().listen((changes) {
      state = state.copyWith(pending: changes);
      if (changes > 0) _later();
    });
    ref.onDispose(() {
      pending.cancel();
      _timer?.cancel();
    });
    // A user signed in (or the app started with one): sync right away.
    Future.microtask(syncNow);
    return const SyncState(active: true);
  }

  void _later([Duration after = delay]) {
    _timer?.cancel();
    _timer = Timer(after, syncNow);
  }

  Future<void> syncNow() async {
    // Called later (a timer, a microtask): this provider may be gone by then.
    if (!ref.mounted) return;
    final repository = ref.read(syncRepositoryProvider);
    final userId = ref.read(currentUserIdProvider);
    if (repository == null || userId == null) return;

    state = state.copyWith(syncing: true, error: null);
    final result = await repository.sync(userId);
    // Someone else may be signed in by now: this result isn't theirs.
    if (!ref.mounted || ref.read(currentUserIdProvider) != userId) return;
    switch (result) {
      case Right():
        state = state.copyWith(
          syncing: false,
          lastSynced: ref.read(clockProvider)(),
        );
      case Left(value: final failure):
        state = state.copyWith(syncing: false, error: failure.message);
        _later(retryAfter);
    }
  }
}
