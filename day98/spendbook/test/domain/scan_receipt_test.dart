import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/usecases/scan_receipt.dart';

import '../helpers/receipts.dart';

void main() {
  test('the total line, not the subtotal', () {
    final draft = parseReceipt(cafe);
    expect(draft.merchant, 'Kopi Corner');
    expect(draft.total, '10.25');
  });

  test('"Grand total" with the amount on the next line', () {
    final draft = parseReceipt(market);
    expect(draft.merchant, 'FRESH MART');
    expect(draft.total, '1028.40'); // no comma: ready for the form
  });

  test('no total line: the biggest amount', () {
    final draft = parseReceipt(['Taxi', 'Fare 18.40', 'Tip 2.00']);
    expect(draft.total, '18.40');
  });

  test('numbers that are not amounts are ignored', () {
    final draft = parseReceipt(['Receipt 2026.10.28', 'Ref 12345.678']);
    expect(draft.total, isNull);
    expect(draft.merchant, isNull); // every line has digits
  });

  test('a photo without text is a ValidationFailure', () async {
    final scan = ScanReceipt(FakeReader(right(['', '  '])));
    final result = await scan('photo.jpg');
    expect(result.getLeft().toNullable(), isA<ValidationFailure>());
  });

  test("the reader's failure is passed on", () async {
    final scan = ScanReceipt(
      FakeReader(left(const ValidationFailure("Couldn't read this photo."))),
    );
    final result = await scan('photo.jpg');
    expect(result.getLeft().toNullable()?.message, "Couldn't read this photo.");
  });
}
