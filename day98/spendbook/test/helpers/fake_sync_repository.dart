import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/repositories/sync_repository.dart';

/// Records what was asked. Set [failWith] to make sync fail.
class FakeSyncRepository implements SyncRepository {
  final synced = <String>[];
  var cleared = false;
  Failure? failWith;
  final pending = StreamController<int>.broadcast();

  /// What watchPendingChanges starts with.
  int pendingNow = 0;

  @override
  Future<Either<Failure, SyncReport>> sync(String userId) async {
    if (failWith case final failure?) return left(failure);
    synced.add(userId);
    return right(const SyncReport(uploaded: 0, downloaded: 0));
  }

  @override
  Stream<int> watchPendingChanges() async* {
    yield pendingNow;
    yield* pending.stream;
  }

  @override
  Future<Either<Failure, Unit>> clearLocal() async {
    cleared = true;
    return right(unit);
  }
}
