/// Everything that can go wrong, as values the UI shows (Day 56).
///
/// Trip Buddy throws them (in futures and streams) and the screens catch
/// them: `sealed`, so a `switch` must cover every kind.
sealed class Failure implements Exception {
  const Failure(this.message);

  /// A message a user can understand.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The input breaks a rule, e.g. an empty question.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Reading or writing the device's storage failed.
final class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

/// A server couldn't be reached.
final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// An AI service couldn't give a usable answer: not set up, over the
/// quota, App Check rejected the app, or an answer the app can't use.
final class AiFailure extends Failure {
  const AiFailure(super.message);
}
