import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/exchange_rate.dart';
import '../../domain/failures.dart';
import '../../domain/repositories/exchange_rate_repository.dart';
import '../remote/frankfurter_api.dart';

class FrankfurterExchangeRateRepository implements ExchangeRateRepository {
  FrankfurterExchangeRateRepository(this._api, {required this._now});

  final FrankfurterApi _api;
  final DateTime Function() _now;

  /// Rates change once a day: keep each pair for a few hours, so adding
  /// several expenses doesn't call the API every time.
  static const cacheFor = Duration(hours: 6);
  final _cache = <String, ({ExchangeRate rate, DateTime fetchedAt})>{};

  @override
  Future<Either<Failure, ExchangeRate>> latestRate({
    required String from,
    required String to,
  }) async {
    final key = '$from-$to';
    if (_cache[key] case final cached?
        when _now().difference(cached.fetchedAt) < cacheFor) {
      return right(cached.rate);
    }

    try {
      final dto = await _api.latestRate(from, to);
      final rate = ExchangeRate(
        from: dto.base,
        to: dto.quote,
        rate: dto.rate,
        date: dto.date,
      );
      _cache[key] = (rate: rate, fetchedAt: _now());
      return right(rate);
    } on DioException catch (e, stackTrace) {
      log('Exchange rate error', error: e, stackTrace: stackTrace);
      return left(switch (e) {
        // Frankfurter answers 422 for a currency it doesn't know.
        DioException(response: Response(statusCode: 422)) => ValidationFailure(
          "$from can't be converted.",
        ),
        DioException(
          type: DioExceptionType.connectionError ||
              DioExceptionType.connectionTimeout ||
              DioExceptionType.receiveTimeout,
        ) =>
          const NetworkFailure(
            "Couldn't get the exchange rate. Check your connection.",
          ),
        _ => const NetworkFailure("Couldn't get the exchange rate."),
      });
    } on FormatException catch (e, stackTrace) {
      // A 200 answer we can't read: still a failure, not a crash.
      log(
        'Unexpected exchange rate response',
        error: e,
        stackTrace: stackTrace,
      );
      return left(const NetworkFailure("Couldn't read the exchange rate."));
    }
  }
}
