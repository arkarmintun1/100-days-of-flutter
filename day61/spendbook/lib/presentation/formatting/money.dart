import 'package:intl/intl.dart';

/// The app's currency. Day 63 converts other currencies into it.
const appCurrency = 'USD';

final _format = NumberFormat.simpleCurrency(name: appCurrency);

/// 1250 → "$12.50". The double is only for display; sums stay in cents.
String formatCents(int cents) => _format.format(cents / 100);

/// What the user typed → cents, without going through a double:
/// "12" → 1200, "12.5" → 1250, "12.50" → 1250. Null if it isn't an amount
/// (letters, a minus sign, more than 2 decimals, more than 9 digits).
int? parseCents(String text) {
  final match = RegExp(r'^(\d{1,9})(?:\.(\d{1,2}))?$').firstMatch(text.trim());
  if (match == null) return null;
  final units = int.parse(match.group(1)!);
  final decimals = (match.group(2) ?? '').padRight(2, '0');
  return units * 100 + int.parse(decimals);
}
