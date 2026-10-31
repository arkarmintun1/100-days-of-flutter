import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/usecases/convert_currency.dart';

import '../helpers/fake_exchange_rate_repository.dart';

void main() {
  late FakeExchangeRateRepository rates;
  late ConvertCurrency convert;

  setUp(() {
    rates = FakeExchangeRateRepository();
    convert = ConvertCurrency(rates, appCurrency: 'USD');
  });

  test('SGD 16.00 at 0.78047 is USD 12.49', () async {
    final result = await convert(
      const ForeignAmount(currency: 'SGD', minorUnits: 1600, decimalDigits: 2),
    );
    final conversion = result.getOrElse((f) => fail('$f'));
    // 16 × 0.78047 = 12.48752 → rounded to the nearest cent.
    expect(conversion.cents, 1249);
    expect(conversion.rate.rate, 0.78047);
    expect(rates.calls, ['SGD-USD']);
  });

  test('a currency without decimals: JPY 1500', () async {
    final result = await convert(
      const ForeignAmount(currency: 'JPY', minorUnits: 1500, decimalDigits: 0),
    );
    // 1500 × 0.0067 = 10.05
    expect(result.getOrElse((f) => fail('$f')).cents, 1005);
  });

  test('rounds to the nearest cent', () {
    const sgd = ForeignAmount(
      currency: 'SGD',
      minorUnits: 100,
      decimalDigits: 2,
    );
    expect(ConvertCurrency.centsFor(sgd, 0.123), 12); // 12.3 cents
    expect(ConvertCurrency.centsFor(sgd, 0.126), 13); // 12.6 cents
  });

  test('0 is not an amount, and is not sent to the API', () async {
    final result = await convert(
      const ForeignAmount(currency: 'SGD', minorUnits: 0, decimalDigits: 2),
    );
    expect(result.getLeft().toNullable(), isA<ValidationFailure>());
    expect(rates.calls, isEmpty);
  });

  test("the repository's failure is passed on", () async {
    rates.failWith = const NetworkFailure('Offline.');
    final result = await convert(
      const ForeignAmount(currency: 'SGD', minorUnits: 1600, decimalDigits: 2),
    );
    expect(result.getLeft().toNullable(), isA<NetworkFailure>());
  });
}
