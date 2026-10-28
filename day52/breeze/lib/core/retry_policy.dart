import 'package:breeze/core/app_exception.dart';

/// Riverpod retry policy (Day 47): try again up to 3 times, after 1 s, 2 s
/// and 4 s, but only when the error may fix itself.
Duration? retryTransient(int retryCount, Object error) {
  if (retryCount >= 3) return null;
  if (error is! AppException || !error.kind.mayFixItself) return null;
  return Duration(seconds: 1 << retryCount);
}

/// Never retries. Tests use it so a failure shows up right away.
Duration? noRetry(int retryCount, Object error) => null;
