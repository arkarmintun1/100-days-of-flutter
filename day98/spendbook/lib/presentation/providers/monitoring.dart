import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/monitoring/crashlytics_error_reporter.dart';
import '../../data/monitoring/firebase_analytics_tracker.dart';
import '../../domain/repositories/analytics.dart';
import '../../domain/repositories/error_reporter.dart';
import 'auth.dart';

part 'monitoring.g.dart';

/// Day 95: Crashlytics when Firebase is set up; otherwise the debug log.
@Riverpod(keepAlive: true)
ErrorReporter errorReporter(Ref ref) => ref.watch(firebaseReadyProvider)
    ? CrashlyticsErrorReporter(FirebaseCrashlytics.instance)
    : const LogErrorReporter();

/// Day 95: Google Analytics when Firebase is set up; otherwise nothing.
@Riverpod(keepAlive: true)
Analytics analytics(Ref ref) => ref.watch(firebaseReadyProvider)
    ? FirebaseAnalyticsTracker(FirebaseAnalytics.instance)
    : const NoAnalytics();
