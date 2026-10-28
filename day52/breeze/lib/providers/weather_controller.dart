import 'package:breeze/models/weather.dart';
import 'package:breeze/providers/weather_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weather_controller.g.dart';

/// The weather Breeze shows: for the picked city, or where the device is.
///
/// keepAlive: there's only one, and it should survive the search screen.
@Riverpod(keepAlive: true)
class WeatherController extends _$WeatherController {
  @override
  Future<Weather> build() async {
    // The Ref of this build (Day 43): `this.ref` changes when it rebuilds.
    final ref = this.ref;
    final place = ref.watch(selectedPlaceProvider);
    final repository = ref.watch(weatherRepositoryProvider);

    if (place != null) {
      final weather = await repository.getWeather(
        lat: place.lat,
        lon: place.lon,
      );
      // Show the name the user picked (OpenWeatherMap's own name for the
      // position can be a district).
      return weather.copyWith(place: place.name, country: place.country);
    }

    final position = await ref.watch(locationServiceProvider).currentPosition();
    // A city was picked while we waited for the position: this build is
    // outdated. Riverpod ignores its result, so don't spend a request.
    if (!ref.mounted) throw StateError('Outdated build');
    return repository.getWeather(lat: position.lat, lon: position.lon);
  }

  /// Loads the weather again; keeps showing the old one meanwhile.
  /// Completes with the new weather, or throws if it failed.
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
