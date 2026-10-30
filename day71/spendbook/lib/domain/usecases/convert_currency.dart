import 'package:fpdart/fpdart.dart';

import '../entities/exchange_rate.dart';
import '../entities/expense.dart';
import '../failures.dart';
import '../repositories/exchange_rate_repository.dart';

/// The result of a conversion: cents in the app's currency, and the rate
/// that was used.
class Conversion {
  const Conversion({required this.cents, required this.rate});

  final int cents;
  final ExchangeRate rate;
}

/// Converts an amount in another currency into the app's currency (cents).
class ConvertCurrency {
  const ConvertCurrency(this._repository, {required this.appCurrency});

  final ExchangeRateRepository _repository;

  /// The app's currency; it has 2 decimals (cents).
  final String appCurrency;

  Future<Either<Failure, Conversion>> call(ForeignAmount amount) async {
    if (amount.minorUnits <= 0) {
      return left(const ValidationFailure('The amount must be more than 0.'));
    }
    final rate = await _repository.latestRate(
      from: amount.currency,
      to: appCurrency,
    );
    return rate.map(
      (rate) => Conversion(cents: centsFor(amount, rate.rate), rate: rate),
    );
  }

  /// The rate is a double, so this is the one place where rounding
  /// happens: once, to the nearest cent.
  static int centsFor(ForeignAmount amount, double rate) {
    final units = amount.minorUnits / _pow10(amount.decimalDigits);
    return (units * rate * 100).round();
  }

  static int _pow10(int digits) {
    var result = 1;
    for (var i = 0; i < digits; i++) {
      result *= 10;
    }
    return result;
  }
}
