import 'package:breeze/data/api/open_weather_api.dart';
import 'package:breeze/data/location/location_service.dart';
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

/// Tests replace this with a fake location.
@Riverpod(keepAlive: true)
LocationService locationService(Ref ref) => GeolocatorLocationService();

/// Where the device is (asks for permission the first time).
@riverpod
Future<Coordinates> currentPosition(Ref ref) =>
    ref.watch(locationServiceProvider).currentPosition();

/// The weather where the device is.
@riverpod
Future<Weather> localWeather(Ref ref) async {
  final position = await ref.watch(currentPositionProvider.future);
  return ref
      .watch(weatherRepositoryProvider)
      .getWeather(lat: position.lat, lon: position.lon);
}
