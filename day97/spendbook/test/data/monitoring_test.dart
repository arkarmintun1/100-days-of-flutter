import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendbook/data/monitoring/crashlytics_error_reporter.dart';
import 'package:spendbook/data/monitoring/firebase_analytics_tracker.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/repositories/analytics.dart';

class MockAnalytics extends Mock implements FirebaseAnalytics {}

class MockCrashlytics extends Mock implements FirebaseCrashlytics {}

/// Day 95: exactly what goes to Firebase.
void main() {
  test('expense_added: a category and two choices, nothing else', () async {
    final firebase = MockAnalytics();
    when(
      () => firebase.logEvent(
        name: any(named: 'name'),
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer((_) async {});

    await FirebaseAnalyticsTracker(firebase).expenseAdded(
      category: ExpenseCategory.transport,
      otherCurrency: true,
      fromReceipt: false,
    );

    verify(
      () => firebase.logEvent(
        name: 'expense_added',
        parameters: {
          'category': 'transport',
          'currency_type': 'other',
          'entry_method': 'typed',
        },
      ),
    ).called(1);
  });

  test('receipt_scanned: only how it went', () async {
    final firebase = MockAnalytics();
    when(
      () => firebase.logEvent(
        name: any(named: 'name'),
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer((_) async {});

    await FirebaseAnalyticsTracker(firebase)
        .receiptScanned(ReceiptScanResult.noTotal);

    verify(
      () => firebase.logEvent(
        name: 'receipt_scanned',
        parameters: {'result': 'no_total'},
      ),
    ).called(1);
  });

  test('a handled error is a non-fatal in Crashlytics', () async {
    final crashlytics = MockCrashlytics();
    when(
      () => crashlytics.recordError(any(), any(), reason: any(named: 'reason')),
    ).thenAnswer((_) async {});
    final error = StateError('broken');
    final stack = StackTrace.current;

    await CrashlyticsErrorReporter(crashlytics)
        .recordError(error, stack, reason: 'sync');

    verify(() => crashlytics.recordError(error, stack, reason: 'sync'))
        .called(1);
  });
}
