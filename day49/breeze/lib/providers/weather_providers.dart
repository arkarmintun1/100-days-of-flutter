import 'package:breeze/data/api/open_weather_api.dart';
import 'package:breeze/data/repositories/weather_repository.dart';
import 'package:breeze/models/weather.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weather_providers.g.dart';

@Riverpod(keepAlive: true)
OpenWeatherApi openWeatherApi(Ref ref) => OpenWeatherApi();

/// Tests replace this with a fake repository.
@Riverpod(keepAlive: true)
WeatherRepository weatherRepository(Ref ref) =>
    OpenWeatherRepository(ref.watch(openWeatherApiProvider));

/// Day 49: a fixed place to try the API with (Day 50 adds the device's
/// location).
const yangon = (lat: 16.8713, lon: 96.1994);

@riverpod
Future<Weather> yangonWeather(Ref ref) => ref
    .watch(weatherRepositoryProvider)
    .getWeather(lat: yangon.lat, lon: yangon.lon);
