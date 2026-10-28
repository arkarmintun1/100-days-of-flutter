import 'package:breeze/core/app_exception.dart';
import 'package:breeze/data/api/open_weather_api.dart';
import 'package:breeze/data/repositories/weather_repository.dart';
import 'package:breeze/models/weather.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_adapter.dart';
import 'helpers/fake_weather_repository.dart';

void main() {
  test('asks both endpoints for the same position', () async {
    final adapter = FakeAdapter(
      (options) => FakeAdapter.json(
        FakeAdapter.fixture(
          options.path == '/weather' ? 'current_yangon' : 'forecast_yangon',
        ),
      ),
    );
    final repository = OpenWeatherRepository(
      OpenWeatherApi(
        apiKey: 'k',
        dio: Dio(BaseOptions(baseUrl: OpenWeatherApi.baseUrl))
          ..httpClientAdapter = adapter,
      ),
    );

    await repository.getWeather(lat: 16.87, lon: 96.2);

    expect(
      adapter.requests.map((r) => r.path),
      unorderedEquals(['/weather', '/forecast']),
    );
    for (final request in adapter.requests) {
      expect(request.queryParameters['lat'], 16.87);
      expect(request.queryParameters['lon'], 96.2);
    }
  });

  test('turns the two responses into one Weather', () async {
    final weather = await fixtureRepository().getWeather(lat: 0, lon: 0);

    expect(weather.place, 'Yangon');
    expect(weather.country, 'MM');
    expect(weather.utcOffsetSeconds, 23400); // UTC+6:30
    expect(weather.current.temperature, 29.4);
    expect(weather.current.condition.main, 'Rain');
    expect(
      weather.current.condition.iconUrl,
      'https://openweathermap.org/img/wn/10d@2x.png',
    );
    // Unix seconds became UTC DateTimes.
    expect(weather.current.time, DateTime.utc(2026, 10, 28, 4, 20));
    expect(weather.current.sunrise, DateTime.utc(2026, 10, 27, 23, 28));
    expect(weather.hourly, hasLength(40));
    expect(weather.hourly.first.time, DateTime.utc(2026, 10, 28, 6));
    expect(weather.hourly.first.precipitationChance, 0);
    expect(weather.fetchedAt, DateTime.utc(2026, 10, 28, 4, 30));
  });

  test(
    'a failed request throws its AppException, not a ParallelWaitError',
    () async {
      final repository = OpenWeatherRepository(
        OpenWeatherApi(
          apiKey: 'k',
          dio: Dio(BaseOptions(baseUrl: OpenWeatherApi.baseUrl))
            ..httpClientAdapter = FakeAdapter(
              (options) => options.path == '/forecast'
                  ? FakeAdapter.json({'cod': '401'}, status: 401)
                  : FakeAdapter.json(FakeAdapter.fixture('current_yangon')),
            ),
        ),
      );

      expect(
        () => repository.getWeather(lat: 0, lon: 0),
        throwsA(
          isA<AppException>().having(
            (e) => e.kind,
            'kind',
            ErrorKind.unauthorized,
          ),
        ),
      );
    },
  );

  test(
    'a Weather survives a JSON round trip (for saving it, Day 53)',
    () async {
      final weather = await fixtureRepository().getWeather(lat: 0, lon: 0);
      expect(Weather.fromJson(weather.toJson()), weather);
    },
  );

  test('an empty weather list is an AppException too', () async {
    final current = FakeAdapter.fixture('current_yangon')..['weather'] = [];
    final repository = OpenWeatherRepository(
      OpenWeatherApi(
        apiKey: 'k',
        dio: Dio(BaseOptions(baseUrl: OpenWeatherApi.baseUrl))
          ..httpClientAdapter = FakeAdapter(
            (options) => FakeAdapter.json(
              options.path == '/weather'
                  ? current
                  : FakeAdapter.fixture('forecast_yangon'),
            ),
          ),
      ),
    );

    expect(
      () => repository.getWeather(lat: 0, lon: 0),
      throwsA(isA<AppException>()),
    );
  });
}
