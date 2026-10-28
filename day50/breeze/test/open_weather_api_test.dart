import 'package:breeze/core/app_exception.dart';
import 'package:breeze/data/api/open_weather_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_adapter.dart';

void main() {
  (OpenWeatherApi, FakeAdapter) apiWith(
    ResponseBody Function(RequestOptions options) handler,
  ) {
    final adapter = FakeAdapter(handler);
    final api = OpenWeatherApi(
      apiKey: 'test-key',
      dio: Dio(BaseOptions(baseUrl: OpenWeatherApi.baseUrl))
        ..httpClientAdapter = adapter,
    );
    return (api, adapter);
  }

  test('every request carries the API key and metric units', () async {
    final (api, adapter) = apiWith(
      (_) => FakeAdapter.json(FakeAdapter.fixture('current_yangon')),
    );
    await api.currentWeather(16.87, 96.2);

    final request = adapter.requests.single;
    expect(request.path, '/weather');
    expect(request.queryParameters, {
      'lat': 16.87,
      'lon': 96.2,
      'appid': 'test-key',
      'units': 'metric',
    });
  });

  test('parses the current weather', () async {
    final (api, _) = apiWith(
      (_) => FakeAdapter.json(FakeAdapter.fixture('current_yangon')),
    );
    final current = await api.currentWeather(16.87, 96.2);

    expect(current.name, 'Yangon');
    expect(current.main.feelsLike, 34.1);
    expect(current.weather.first.main, 'Rain');
    expect(current.timezone, 23400);
  });

  test('parses the forecast: 40 steps of 3 hours', () async {
    final (api, _) = apiWith(
      (_) => FakeAdapter.json(FakeAdapter.fixture('forecast_yangon')),
    );
    final forecast = await api.forecast(16.87, 96.2);

    expect(forecast.list, hasLength(40));
    expect(forecast.list[1].dt - forecast.list[0].dt, 3 * 3600);
    expect(forecast.city.timezone, 23400);
  });

  group('errors become AppExceptions', () {
    Future<AppException> errorFor(ResponseBody body) async {
      final (api, _) = apiWith((_) => body);
      try {
        await api.currentWeather(0, 0);
      } on AppException catch (e) {
        return e;
      }
      throw StateError('expected an AppException');
    }

    test('401 means a bad API key', () async {
      final e = await errorFor(
        FakeAdapter.json({
          'cod': 401,
          'message': 'Invalid API key.',
        }, status: 401),
      );
      expect(e.kind, ErrorKind.unauthorized);
    });

    test('429 means too many requests', () async {
      final e = await errorFor(FakeAdapter.json({'cod': 429}, status: 429));
      expect(e.kind, ErrorKind.rateLimited);
    });

    test('5xx is a server problem', () async {
      final e = await errorFor(FakeAdapter.json({}, status: 503));
      expect(e.kind, ErrorKind.server);
    });

    test('JSON with the wrong shape', () async {
      final e = await errorFor(FakeAdapter.json({'weather': 'sunny'}));
      expect(e.kind, ErrorKind.unknown);
    });
  });

  test('no connection', () async {
    final (api, _) = apiWith(
      (options) => throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      ),
    );
    expect(
      () => api.forecast(0, 0),
      throwsA(
        isA<AppException>().having((e) => e.kind, 'kind', ErrorKind.network),
      ),
    );
  });
}
