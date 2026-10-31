import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/repositories/analytics.dart';

/// Day 95: remembers the events instead of sending them.
class FakeAnalytics implements Analytics {
  final events = <String>[];

  @override
  Future<void> expenseAdded({
    required ExpenseCategory category,
    required bool otherCurrency,
    required bool fromReceipt,
  }) async => events.add(
    'expense_added ${category.name}'
    '${otherCurrency ? ' other currency' : ''}'
    '${fromReceipt ? ' from receipt' : ''}',
  );

  @override
  Future<void> receiptScanned(ReceiptScanResult result) async =>
      events.add('receipt_scanned ${result.name}');
}
