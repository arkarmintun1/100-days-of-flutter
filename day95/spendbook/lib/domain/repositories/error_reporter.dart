import 'dart:developer';

/// Day 95: errors the app handled (the user saw a message) but that
/// shouldn't happen, so the developer hears about them too.
abstract interface class ErrorReporter {
  /// [reason] says where it happened, e.g. 'sync'. Never put what people
  /// typed (titles, notes, amounts) in it.
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    required String reason,
  });
}

/// Without Firebase: only the debug log, as before Day 95.
class LogErrorReporter implements ErrorReporter {
  const LogErrorReporter();

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    required String reason,
  }) async => log(reason, error: error, stackTrace: stackTrace);
}
