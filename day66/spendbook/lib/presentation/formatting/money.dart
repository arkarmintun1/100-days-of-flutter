import 'package:intl/intl.dart';

/// The app's currency. Other currencies are converted into it (Day 63).
const appCurrency = 'USD';

/// The currencies the add form offers (all supported by Frankfurter).
const currencies = [
  'USD', 'EUR', 'GBP', 'JPY', 'SGD', 'THB', 'MYR', 'MMK', 'CNY', 'INR', //
];

final _format = NumberFormat.simpleCurrency(name: appCurrency);

/// 1250 → "$12.50". The double is only for display; sums stay in cents.
String formatCents(int cents) => _format.format(cents / 100);

/// How many decimals a currency has, from the CLDR data in intl:
/// 2 for USD and SGD, 0 for JPY and MMK.
int decimalDigitsOf(String currency) =>
    NumberFormat.simpleCurrency(name: currency).decimalDigits!;

/// 1600 SGD (2 decimals) → "SGD 16.00". The code, not a symbol: "$" could
/// be USD or SGD.
String formatMinor(int minorUnits, String currency) {
  final digits = decimalDigitsOf(currency);
  final format = NumberFormat.currency(
    name: currency,
    symbol: '$currency ',
    decimalDigits: digits,
  );
  return format.format(minorUnits / _pow10(digits));
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
