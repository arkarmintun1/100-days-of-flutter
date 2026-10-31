import 'package:fpdart/fpdart.dart';
import 'package:spendbook/domain/entities/exchange_rate.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/repositories/exchange_rate_repository.dart';

/// Fixed rates into USD; anything else is "unsupported". Set [failWith] to
/// fail every call.
class FakeExchangeRateRepository implements ExchangeRateRepository {
  FakeExchangeRateRepository([
    this.toUsd = const {'SGD': 0.78047, 'JPY': 0.0067},
  ]);

  final Map<String, double> toUsd;
  Failure? failWith;
  final calls = <String>[];

  @override
  Future<Either<Failure, ExchangeRate>> latestRate({
    required String from,
    required String to,
  }) async {
    calls.add('$from-$to');
    if (failWith case final failure?) return left(failure);
    final rate = toUsd[from];
    if (rate == null || to != 'USD') {
      return left(ValidationFailure("$from can't be converted."));
    }
    return right(
      ExchangeRate(
        from: from,
        to: to,
        rate: rate,
        date: DateTime(2026, 10, 28),
      ),
    );
  }
}
