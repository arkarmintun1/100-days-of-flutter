import 'package:intl/intl.dart';

/// The app's currency. Other currencies are converted into it (Day 63).
const appCurrency = 'USD';

/// The currencies the add form offers (all supported by Frankfurter).
const currencies = [
  'USD', 'EUR', 'GBP', 'JPY', 'SGD', 'THB', 'MYR', 'MMK', 'CNY', 'INR', //
];

/// 1250 → "$12.50" in English, "၁၂.၅၀ $" in Myanmar ([locale], Day 96;
/// null: intl's default locale). The double is only for display; sums
/// stay in cents.
String formatCents(int cents, [String? locale]) => NumberFormat.simpleCurrency(
  locale: locale,
  name: appCurrency,
).format(cents / 100);

/// Day 96: 62 → "62" or "၆၂", in the locale's digits.
String formatNumber(int number, [String? locale]) =>
    NumberFormat.decimalPattern(locale).format(number);

/// How many decimals a currency has, from the CLDR data in intl:
/// 2 for USD and SGD, 0 for JPY and MMK.
int decimalDigitsOf(String currency) =>
    NumberFormat.simpleCurrency(name: currency).decimalDigits!;

/// 1600 SGD (2 decimals) → "SGD 16.00". The code, not a symbol: "$" could
/// be USD or SGD.
String formatMinor(int minorUnits, String currency, [String? locale]) {
  final digits = decimalDigitsOf(currency);
  final format = NumberFormat.currency(
    locale: locale,
    name: currency,
    symbol: '$currency ',
    decimalDigits: digits,
  );
  // trim: in Myanmar the symbol goes after the amount ("၁၆.၀၀ SGD").
  return format.format(minorUnits / _pow10(digits)).trim();
}

/// What the user typed → cents, without going through a double:
/// "12" → 1200, "12.5" → 1250, "12.50" → 1250. Null if it isn't an amount
/// (letters, a minus sign, more than 2 decimals, more than 9 digits).
int? parseCents(String text) => parseMinor(text, decimalDigits: 2);

/// Like [parseCents], for a currency with [decimalDigits] decimals:
/// "1500" JPY (0 decimals) → 1500, "15.5" JPY → null.
int? parseMinor(String text, {required int decimalDigits}) {
  final pattern = decimalDigits == 0
      ? RegExp(r'^(\d{1,9})$')
      : RegExp('^(\\d{1,9})(?:\\.(\\d{1,$decimalDigits}))?\$');
  final match = pattern.firstMatch(text.trim());
  if (match == null) return null;
  final units = int.parse(match.group(1)!);
  if (decimalDigits == 0) return units;
  final decimals = (match.group(2) ?? '').padRight(decimalDigits, '0');
  return units * _pow10(decimalDigits) + int.parse(decimals);
}

int _pow10(int digits) {
  var result = 1;
  for (var i = 0; i < digits; i++) {
    result *= 10;
  }
  return result;
}
