import 'expense_category.dart';

/// What could be read from a receipt photo. Anything can be missing: the
/// user checks it in the form before saving.
class ReceiptDraft {
  const ReceiptDraft({
    this.merchant,
    this.total,
    this.currency,
    this.date,
    this.category,
  });

  /// Usually the shop's name, at the top of the receipt.
  final String? merchant;

  /// The total as plain digits, e.g. "1234.50" (no currency, no commas),
  /// ready for the amount field.
  final String? total;

  // Day 72: Gemini can read these too. ML Kit's parser leaves them null.

  /// A 3-letter ISO 4217 code, e.g. "SGD".
  final String? currency;

  /// The day on the receipt.
  final DateTime? date;

  /// A guess from what was bought.
  final ExpenseCategory? category;
}
