import '../entities/expense_category.dart';

/// Day 95: what people do in the app, never what they write or spend.
/// One method per event, so nothing else can be sent by accident.
abstract interface class Analytics {
  Future<void> expenseAdded({
    required ExpenseCategory category,
    required bool otherCurrency,

    /// A receipt scan was used on the form (it may have filled nothing).
    required bool fromReceipt,
  });

  Future<void> receiptScanned(ReceiptScanResult result);
}

enum ReceiptScanResult {
  /// The form got a total.
  total,

  /// Read, but no total found.
  noTotal,

  /// Couldn't read the photo.
  failed,
}

/// Without Firebase: nothing is sent.
class NoAnalytics implements Analytics {
  const NoAnalytics();

  @override
  Future<void> expenseAdded({
    required ExpenseCategory category,
    required bool otherCurrency,
    required bool fromReceipt,
  }) async {}

  @override
  Future<void> receiptScanned(ReceiptScanResult result) async {}
}
