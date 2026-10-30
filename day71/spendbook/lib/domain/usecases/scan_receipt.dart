import 'package:fpdart/fpdart.dart';

import '../entities/receipt_draft.dart';
import '../failures.dart';
import '../repositories/receipt_text_reader.dart';

/// Photo → text (data layer) → merchant and total (here, pure Dart).
class ScanReceipt {
  const ScanReceipt(this._reader);

  final ReceiptTextReader _reader;

  Future<Either<Failure, ReceiptDraft>> call(String imagePath) async {
    final lines = await _reader.readLines(imagePath);
    return lines.flatMap((lines) {
      if (lines.every((line) => line.trim().isEmpty)) {
        return left(
          const ValidationFailure('No text found. Try a clearer photo.'),
        );
      }
      return right(parseReceipt(lines));
    });
  }
}

/// An amount with 2 decimals: "12.50", "1,234.56". Not part of a longer
/// number, so "12345.678" or a date like "2026.10.28" won't match.
final _amount = RegExp(
  r'(?<![\d.,])(\d{1,3}(?:,\d{3})+|\d+)\.(\d{2})(?!\d|\.\d)',
);

/// Lines that usually hold the amount to pay, strongest first.
const _totalWords = ['grand total', 'amount due', 'balance due', 'total'];

/// Lines with "total" that are not the total.
const _notTheTotal = [
  'subtotal',
  'sub total',
  'sub-total',
  'total qty',
  'total items',
];

/// Finds the merchant and the total in the lines of a receipt.
ReceiptDraft parseReceipt(List<String> lines) {
  final clean = [for (final line in lines) line.trim()];
  return ReceiptDraft(merchant: _merchant(clean), total: _total(clean));
}

String? _merchant(List<String> lines) {
  for (final line in lines.take(5)) {
    final letters = RegExp('[A-Za-z]').allMatches(line).length;
    if (letters >= 3 && !RegExp(r'\d').hasMatch(line)) {
      return line.length > 60 ? line.substring(0, 60) : line;
    }
  }
  return null;
}

String? _total(List<String> lines) {
  for (final word in _totalWords) {
    // The last match: "TOTAL" near the end beats an earlier one.
    for (var i = lines.length - 1; i >= 0; i--) {
      final line = lines[i].toLowerCase();
      if (!line.contains(word) || _notTheTotal.any(line.contains)) continue;
      // The amount is on the same line, or on the next one.
      final amount =
          _lastAmount(lines[i]) ??
          (i + 1 < lines.length ? _lastAmount(lines[i + 1]) : null);
      if (amount != null) return amount;
    }
  }
  // No "total" line: the biggest amount is usually the total.
  final all = [for (final line in lines) ..._amounts(line)];
  if (all.isEmpty) return null;
  all.sort((a, b) => double.parse(b).compareTo(double.parse(a)));
  return all.first;
}

String? _lastAmount(String line) {
  final amounts = _amounts(line);
  return amounts.isEmpty ? null : amounts.last;
}

/// "1,234.56" → "1234.56".
List<String> _amounts(String line) => [
  for (final m in _amount.allMatches(line))
    '${m.group(1)!.replaceAll(',', '')}.${m.group(2)}',
];
