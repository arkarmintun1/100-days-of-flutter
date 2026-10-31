import 'package:fpdart/fpdart.dart';

import '../failures.dart';

/// Day 91: keeps this phone's expenses and the account's copy in the
/// cloud the same. The domain doesn't know it's Firestore.
abstract interface class SyncRepository {
  /// Uploads this phone's changes, then downloads the other phones'.
  Future<Either<Failure, SyncReport>> sync(String userId);

  /// How many changes on this phone wait for an upload, now and later.
  Stream<int> watchPendingChanges();

  /// Forgets the expenses on this phone (after signing out).
  Future<Either<Failure, Unit>> clearLocal();
}

/// What one sync did.
class const SyncReport({
  required final int uploaded,
  required final int downloaded,
});
