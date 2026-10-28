import 'package:pixly/core/app_exception.dart';

/// Pixly's Riverpod retry policy: when a provider fails with an error that
/// may fix itself, try again up to [maxRetries] times, waiting 1 s, 2 s,
/// then 4 s (exponential backoff).
///
/// Riverpod calls it after every failure with the number of retries so far.
/// Returning a Duration retries after that delay; null gives up and shows
/// the error.
Duration? retryTransient(int retryCount, Object error) {
  if (retryCount >= maxRetries) return null;
  // Only our own API errors. Anything else (a bug, an Error) is not
  // going to fix itself.
  if (error is! AppException || !error.kind.mayFixItself) return null;
  return Duration(seconds: 1 << retryCount); // 1, 2, 4
}

const maxRetries = 3;

/// Never retries. Tests use it so a failure shows up right away.
Duration? noRetry(int retryCount, Object error) => null;
