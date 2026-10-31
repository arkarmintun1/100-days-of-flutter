import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../domain/repositories/error_reporter.dart';

/// Day 95: a non-fatal error in Crashlytics (fatal: false is the default).
class CrashlyticsErrorReporter implements ErrorReporter {
  CrashlyticsErrorReporter(this._crashlytics);

  final FirebaseCrashlytics _crashlytics;

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    required String reason,
  }) => _crashlytics.recordError(error, stackTrace, reason: reason);
}
