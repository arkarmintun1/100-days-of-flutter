import 'package:breeze/data/api/open_weather_api.dart';
import 'package:breeze/data/repositories/weather_repository.dart';
import 'package:breeze/models/place.dart';
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
  FakeWeatherRepository(this.onGetWeather, {this.onSearch});

  final Future<Weather> Function(double lat, double lon) onGetWeather;
  final Future<List<Place>> Function(String query)? onSearch;
  final List<(double, double)> calls = [];
  final List<String> searches = [];

  @override
  Future<Weather> getWeather({required double lat, required double lon}) {
    calls.add((lat, lon));
    return onGetWeather(lat, lon);
  }

  @override
  Future<List<Place>> searchPlaces(String query) {
    searches.add(query);
    return onSearch?.call(query) ?? Future.value(const [mandalay]);
  }
}

/// A search result for tests.
const mandalay = Place(
  name: 'Mandalay',
  country: 'MM',
  lat: 21.9588,
  lon: 96.0891,
);
