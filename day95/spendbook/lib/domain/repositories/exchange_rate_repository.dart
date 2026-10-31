import 'package:fpdart/fpdart.dart';

import '../entities/exchange_rate.dart';
import '../failures.dart';

abstract interface class ExchangeRateRepository {
  /// The latest rate from one currency to another (ISO 4217 codes).
  Future<Either<Failure, ExchangeRate>> latestRate({
    required String from,
    required String to,
  });
}
