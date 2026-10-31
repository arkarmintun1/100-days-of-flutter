/// Everything that can go wrong, as values the UI must handle.
///
/// `sealed`: all direct subtypes are in this file, so a `switch` over a
/// Failure must cover every one of them (the compiler checks it).
sealed class Failure {
  const Failure(this.message);

  /// A message a user can understand.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The input breaks a business rule, e.g. an empty title.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// There's no expense with this id.
final class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// Reading or writing the device's storage failed.
final class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

/// A server couldn't be reached, or failed (Day 63).
final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// An AI model couldn't give a usable answer (Day 70): blocked, over the
/// quota, not set up, or an answer the app can't use.
final class AiFailure extends Failure {
  const AiFailure(super.message);
}

/// Signing in or making an account failed (Day 90): a wrong password, an
/// email that's taken, sign-in not set up in Firebase.
final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Day 91: signing out would lose [changes] expenses that couldn't be
/// uploaded, because of [cause] (often no connection).
final class UnsavedChangesFailure extends Failure {
  UnsavedChangesFailure(this.changes, this.cause)
    : super(
        '$changes ${changes == 1 ? 'change' : 'changes'} on this phone '
        "couldn't be saved online (${cause.message})",
      );

  final int changes;
  final Failure cause;
}
