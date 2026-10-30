/// What could be read from a receipt photo. Anything can be missing: the
/// user checks it in the form before saving.
class ReceiptDraft {
  const ReceiptDraft({this.merchant, this.total});

  /// Usually the shop's name, at the top of the receipt.
  final String? merchant;

  /// The total as plain digits, e.g. "1234.50" (no currency, no commas),
  /// ready for the amount field.
  final String? total;
}
