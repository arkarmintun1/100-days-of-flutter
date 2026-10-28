import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/presentation/formatting/money.dart';

void main() {
  test('formats cents as dollars', () {
    expect(formatCents(1250), r'$12.50');
    expect(formatCents(5), r'$0.05');
    expect(formatCents(123456), r'$1,234.56');
  });

  test('parses what the user typed into cents', () {
    expect(parseCents('12'), 1200);
    expect(parseCents('12.5'), 1250);
    expect(parseCents('12.50'), 1250);
    expect(parseCents('0.05'), 5);
    expect(parseCents(' 7 '), 700);
  });

  test('rejects what is not an amount', () {
    for (final text in ['', 'abc', '12.345', '-5', '1,000', '.5', '12.']) {
      expect(parseCents(text), isNull, reason: text);
    }
    expect(parseCents('1234567890'), isNull); // more than 9 digits
  });
}
