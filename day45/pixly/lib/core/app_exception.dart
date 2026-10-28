import 'package:pixly/core/error_kind.dart';
import 'package:pixly/core/result.dart';

/// An error a provider can throw, so it ends up in an [AsyncError] with
/// everything the UI needs to show it.
class AppException implements Exception {
  const AppException(this.message, {this.kind = ErrorKind.unknown});

  /// Turns any error from an AsyncValue into something we can show.
  factory AppException.from(Object error) => switch (error) {
    final AppException e => e,
    _ => const AppException('Something went wrong. Please try again.'),
  };

  final String message;
  final ErrorKind kind;

  @override
  String toString() => 'AppException($kind): $message';
}

extension FailureToException<T> on Failure<T> {
  AppException get exception => AppException(message, kind: kind);
}
