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
