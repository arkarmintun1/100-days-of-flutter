import 'package:firebase_analytics/firebase_analytics.dart';

import '../../domain/entities/expense_category.dart';
import '../../domain/repositories/analytics.dart';

/// Day 95: the events, in Google Analytics for Firebase. Only categories
/// and choices: no titles, notes, amounts or dates.
class FirebaseAnalyticsTracker implements Analytics {
  FirebaseAnalyticsTracker(this._analytics);

  final FirebaseAnalytics _analytics;

  @override
  Future<void> expenseAdded({
    required ExpenseCategory category,
    required bool otherCurrency,
    required bool fromReceipt,
  }) => _analytics.logEvent(
    name: 'expense_added',
    parameters: {
      'category': category.name,
      // Parameter values are strings or numbers. Our own names: `currency`
      // and `source` already mean something else in Analytics.
      'currency_type': otherCurrency ? 'other' : 'home',
      'entry_method': fromReceipt ? 'receipt' : 'typed',
    },
  );

  @override
  Future<void> receiptScanned(ReceiptScanResult result) => _analytics.logEvent(
    name: 'receipt_scanned',
    parameters: {
      'result': switch (result) {
        ReceiptScanResult.total => 'total',
        ReceiptScanResult.noTotal => 'no_total',
        ReceiptScanResult.failed => 'failed',
      },
    },
  );
}
