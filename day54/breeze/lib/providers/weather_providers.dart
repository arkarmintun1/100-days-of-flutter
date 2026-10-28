import 'dart:convert';

import 'package:breeze/data/api/open_weather_api.dart';
import 'package:breeze/data/location/location_service.dart';
import 'package:breeze/data/repositories/weather_repository.dart';
import 'package:breeze/models/place.dart';
import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_sqflite/riverpod_sqflite.dart';
import 'package:sqflite/sqflite.dart';

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

/// The SQLite database for Riverpod's offline persistence (Day 48).
/// Tests override it with Storage.inMemory().
@Riverpod(keepAlive: true)
Future<Storage<String, String>> storage(Ref ref) async {
  final storage = await JsonSqFliteStorage.open(
    join(await getDatabasesPath(), 'breeze.db'),
  );
  ref.onDispose(storage.close);
  return storage;
}

/// Which place the weather is for: a city the user picked, or null for
/// "where I am". Saved on the device, so the app opens on the same place.
@Riverpod(keepAlive: true)
class SelectedPlace extends _$SelectedPlace {
  @override
  Future<Place?> build() async {
    // Awaited: the weather must not ask for the location before we know
    // whether the user picked a city last time.
    await persist(
      ref.watch(storageProvider.future),
      key: 'selected_place',
      encode: (place) => jsonEncode(place?.toJson()),
      decode: (json) => switch (jsonDecode(json)) {
        final Map<String, dynamic> place => Place.fromJson(place),
        _ => null,
      },
      // A choice the user made: keep it until they change it.
      options: const StorageOptions(cacheTime: StorageCacheTime.unsafe_forever),
    ).future;
    return state.value;
  }

  void select(Place place) => state = AsyncData(place);

  void useMyLocation() => state = const AsyncData(null);
}

/// Cities matching [query], for the search screen.
@riverpod
Future<List<Place>> placeSearch(Ref ref, String query) {
  if (query.trim().isEmpty) return Future.value(const []);
  return ref.watch(weatherRepositoryProvider).searchPlaces(query.trim());
}

/// The current time. Tests override it to get a fixed "now".
@Riverpod(keepAlive: true)
DateTime Function() clock(Ref ref) => DateTime.now;
