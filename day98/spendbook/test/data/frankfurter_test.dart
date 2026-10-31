import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/data/remote/frankfurter_api.dart';
import 'package:spendbook/data/repositories/frankfurter_exchange_rate_repository.dart';
import 'package:spendbook/domain/failures.dart';

import '../helpers/fake_adapter.dart';

void main() {
  late DateTime now;
  late FakeAdapter adapter;

  FrankfurterExchangeRateRepository repository(
    ResponseBody Function(RequestOptions) handler,
  ) {
    adapter = FakeAdapter(handler);
    final dio = Dio(BaseOptions(baseUrl: 'https://api.frankfurter.dev/v2'))
      ..httpClientAdapter = adapter;
    return FrankfurterExchangeRateRepository(
      FrankfurterApi(dio),
      now: () => now,
    );
  }

  setUp(() => now = DateTime(2026, 10, 28, 9));

  test('reads a real response', () async {
    // Saved from api.frankfurter.dev on 2026-10-28.
    final repo = repository(
      (_) => FakeAdapter.json(FakeAdapter.fixture('rate_sgd_usd')),
    );

    final rate = (await repo.latestRate(
      from: 'SGD',
      to: 'USD',
    )).getOrElse((f) => fail('$f'));
    expect(rate.from, 'SGD');
    expect(rate.to, 'USD');
    expect(rate.rate, 0.78047);
    expect(rate.date, DateTime(2026, 10, 28));
    expect(
      adapter.requests.single.uri.toString(),
      'https://api.frankfurter.dev/v2/rate/SGD/USD',
    );
  });

  test('a rate is kept for 6 hours', () async {
    final repo = repository(
      (_) => FakeAdapter.json(FakeAdapter.fixture('rate_sgd_usd')),
    );

    await repo.latestRate(from: 'SGD', to: 'USD');
    now = now.add(const Duration(hours: 5));
    await repo.latestRate(from: 'SGD', to: 'USD');
    expect(adapter.requests, hasLength(1)); // from the cache

    now = now.add(const Duration(hours: 2));
    await repo.latestRate(from: 'SGD', to: 'USD');
    expect(adapter.requests, hasLength(2)); // 7 hours: asked again
  });

  test('an answer in another shape is a NetworkFailure', () async {
    final repo = repository(
      (_) => FakeAdapter.json({'date': 'yesterday', 'rate': 'high'}),
    );

    final result = await repo.latestRate(from: 'SGD', to: 'USD');
    expect(result.getLeft().toNullable(), isA<NetworkFailure>());
  });

  test('an unknown currency (422) is a ValidationFailure', () async {
    final repo = repository(
      (_) => FakeAdapter.json({
        'status': 422,
        'message': 'invalid currency: XYZ',
      }, status: 422),
    );

    final result = await repo.latestRate(from: 'XYZ', to: 'USD');
    expect(
      result.getLeft().toNullable(),
      isA<ValidationFailure>().having(
        (f) => f.message,
        'message',
        "XYZ can't be converted.",
      ),
    );
  });

  test('no connection is a NetworkFailure', () async {
    final repo = repository(
      (options) => throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      ),
    );

    final result = await repo.latestRate(from: 'SGD', to: 'USD');
    expect(
      result.getLeft().toNullable(),
      isA<NetworkFailure>().having(
        (f) => f.message,
        'message',
        contains('Check your connection'),
      ),
    );
  });
}
