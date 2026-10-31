import 'package:fpdart/fpdart.dart';

import '../failures.dart';
import '../repositories/auth_repository.dart';
import '../repositories/sync_repository.dart';

/// Day 91: signs out without losing anything. Changes not uploaded yet are
/// uploaded first; then this phone forgets the account's data, so the next
/// person on it doesn't see it.
class const SignOut(final AuthRepository _auth, final SyncRepository _sync) {
  /// With [force], signs out even if changes can't be uploaded: they are
  /// lost (the user said yes to that).
  Future<Either<Failure, Unit>> call(
    String userId, {
    bool force = false,
  }) async {
    final pending = await _sync.watchPendingChanges().first;
    if (pending > 0 && !force) {
      final synced = await _sync.sync(userId);
      if (synced case Left(value: final failure)) {
        return left(UnsavedChangesFailure(pending, failure));
      }
    }
    final signedOut = await _auth.signOut();
    if (signedOut.isLeft()) return signedOut;
    return _sync.clearLocal();
  }
}
