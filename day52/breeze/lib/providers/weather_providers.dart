import 'package:breeze/data/api/open_weather_api.dart';
import 'package:breeze/data/location/location_service.dart';
import 'package:breeze/data/repositories/weather_repository.dart';
import 'package:breeze/models/place.dart';
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

/// Which place the weather is for: a city the user picked, or null for
/// "where I am".
@Riverpod(keepAlive: true)
class SelectedPlace extends _$SelectedPlace {
  @override
  Place? build() => null;

  void select(Place place) => state = place;

  void useMyLocation() => state = null;
}

/// Cities matching [query], for the search screen.
@riverpod
Future<List<Place>> placeSearch(Ref ref, String query) {
  if (query.trim().isEmpty) return Future.value(const []);
  return ref.watch(weatherRepositoryProvider).searchPlaces(query.trim());
}
