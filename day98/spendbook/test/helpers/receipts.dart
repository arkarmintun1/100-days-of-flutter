import 'package:fpdart/fpdart.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/repositories/receipt_text_reader.dart';

/// Example receipts as OCR returns them: one string per line.
const cafe = [
  'Kopi Corner',
  '12 Orchard Road #01-23',
  'Tel: 6234 5678',
  '2x Kopi C        3.60',
  'Kaya Toast Set   5.80',
  'Subtotal         9.40',
  'GST 9%           0.85',
  'TOTAL           10.25',
  'Thank you!',
];

const market = [
  'FRESH MART',
  'Apples           12.90',
  'Rice 5kg         15.50',
  'Grand Total',
  '1,028.40', // on the next line
  'Total items: 2',
];

class FakeReader implements ReceiptTextReader {
  FakeReader(this.result);

  final Either<Failure, List<String>> result;

  @override
  Future<Either<Failure, List<String>>> readLines(String imagePath) async =>
      result;
}
