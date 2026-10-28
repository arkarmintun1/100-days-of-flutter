import 'dart:convert';

import 'package:breeze/core/app_exception.dart';
import 'package:breeze/data/location/location_service.dart';
import 'package:breeze/data/repositories/weather_repository.dart';
import 'package:breeze/models/place.dart';
import 'package:breeze/models/weather.dart';
import 'package:breeze/providers/weather_providers.dart';
import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weather_controller.g.dart';

/// The weather Breeze shows: for the picked city, or where the device is.
///
/// keepAlive: there's only one, and it should survive the search screen.
@Riverpod(keepAlive: true)
class WeatherController extends _$WeatherController {
  /// Which place the weather in `state` belongs to (see [_keyFor]).
  String? _shownKey;

  /// One saved weather per place, so a city's weather is never shown
  /// as "where I am" (or the other way round).
  static String _keyFor(Place? place) =>
      place == null ? 'weather_here' : 'weather_${place.lat}_${place.lon}';

  @override
  Future<Weather> build() async {
    // The Ref of this build (Day 43): `this.ref` changes when it rebuilds.
    final ref = this.ref;
    // All dependencies first, before any await.
    final placeFuture = ref.watch(selectedPlaceProvider.future);
    final storage = ref.watch(storageProvider.future);
    final repository = ref.watch(weatherRepositoryProvider);
    final location = ref.watch(locationServiceProvider);

    final place = await placeFuture;
    // The place changed meanwhile: a newer build loads the weather.
    if (!ref.mounted) throw StateError('Outdated build');
    final key = _keyFor(place);

    // Day 53: the first time, show the weather saved last time while the
    // new one loads; every time, save each new weather.
    await persist(
      storage,
      key: key,
      encode: (weather) => jsonEncode(weather.toJson()),
      decode: (json) {
        final weather = Weather.fromJson(
          jsonDecode(json) as Map<String, dynamic>,
        );
        // Only runs when the weather saved under this key is restored.
        if (ref.mounted) _shownKey = key;
        return weather;
      },
      options: const StorageOptions(
        cacheTime: StorageCacheTime(Duration(days: 2)),
      ),
    ).future;
    if (!ref.mounted) throw StateError('Outdated build');

    try {
      final weather = await _fetch(ref, place, repository, location);
      // A newer build started meanwhile: leave _shownKey to it.
      if (!ref.mounted) throw StateError('Outdated build');
      _shownKey = key;
      return weather;
    } on AppException catch (e) {
      // Location problems show their error: the user can fix them.
      if (e.kind.isLocationProblem) rethrow;
      // Offline or the server failed, but we have the last weather of
      // this same place? Keep it, marked as stale, instead of an error.
      // An AsyncError would also make persist() delete it (Day 48).
      if (state.value case final shown? when _shownKey == key) {
        return shown.copyWith(isStale: true);
      }
      rethrow;
    }
  }

  Future<Weather> _fetch(
    Ref ref,
    Place? place,
    WeatherRepository repository,
    LocationService location,
  ) async {
    if (place != null) {
      final weather = await repository.getWeather(
        lat: place.lat,
        lon: place.lon,
      );
      // Show the name the user picked (OpenWeatherMap's own name for the
      // position can be a district).
      return weather.copyWith(place: place.name, country: place.country);
    }

    final position = await location.currentPosition();
    // A city was picked while we waited for the position: this build is
    // outdated. Riverpod ignores its result, so don't spend a request.
    if (!ref.mounted) throw StateError('Outdated build');
    return repository.getWeather(lat: position.lat, lon: position.lon);
  }

  /// Loads the weather again; keeps showing the old one meanwhile.
  /// Completes when it's done, also when the saved weather is shown
  /// as stale (Day 53); throws if there's no weather to show.
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
