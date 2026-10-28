import 'package:breeze/data/api/open_weather_api.dart';
import 'package:breeze/data/repositories/weather_repository.dart';
import 'package:breeze/models/weather.dart';
import 'package:dio/dio.dart';

import 'fake_adapter.dart';

/// A real OpenWeatherRepository on top of the fixture JSON files, with a
/// fixed clock. Good for tests that want realistic data.
OpenWeatherRepository fixtureRepository() => OpenWeatherRepository(
  OpenWeatherApi(
    apiKey: 'test-key',
    dio: Dio(BaseOptions(baseUrl: OpenWeatherApi.baseUrl))
      ..httpClientAdapter = FakeAdapter(
        (options) => FakeAdapter.json(
          FakeAdapter.fixture(
            options.path == '/weather' ? 'current_yangon' : 'forecast_yangon',
          ),
        ),
      ),
  ),
  now: () => DateTime.utc(2026, 10, 28, 4, 30),
);

/// A repository whose answers are decided by the test.
class FakeWeatherRepository implements WeatherRepository {
  FakeWeatherRepository(this.onGetWeather);

  final Future<Weather> Function(double lat, double lon) onGetWeather;
  final List<(double, double)> calls = [];

  @override
  Future<Weather> getWeather({required double lat, required double lon}) {
    calls.add((lat, lon));
    return onGetWeather(lat, lon);
  }
}
