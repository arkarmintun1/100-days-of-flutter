import 'dart:async';
import 'dart:convert';

import 'package:breeze/app.dart';
import 'package:breeze/core/app_exception.dart';
import 'package:breeze/core/retry_policy.dart';
import 'package:breeze/core/updated_ago.dart';
import 'package:breeze/models/weather.dart';
import 'package:breeze/providers/weather_controller.dart';
import 'package:breeze/providers/weather_providers.dart';
import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_location_service.dart';
import 'helpers/fake_weather_repository.dart';
import 'helpers/test_overrides.dart';

FakeWeatherRepository offline() => FakeWeatherRepository(
  (_, _) async =>
      throw const AppException('Unable to connect.', kind: ErrorKind.network),
);

FakeWeatherRepository online() => FakeWeatherRepository(
  (lat, lon) => fixtureRepository().getWeather(lat: lat, lon: lon),
);

/// The weather the last session saved for "where I am", 2 hours ago.
Future<Storage<String, String>> savedHere() async {
  final storage = Storage<String, String>.inMemory();
  final weather = await fixtureRepository().getWeather(lat: 0, lon: 0);
  await storage.write(
    'weather_here',
    jsonEncode(
      weather
          .copyWith(fetchedAt: testNow.subtract(const Duration(hours: 2)))
          .toJson(),
    ),
    const StorageOptions(),
  );
  return storage;
}

void main() {
  ProviderContainer container(
    FakeWeatherRepository repository,
    Storage<String, String> storage, {
    FakeLocationService? location,
  }) => ProviderContainer.test(
    retry: noRetry,
    overrides: [
      ...deviceOverrides(storage: storage),
      weatherRepositoryProvider.overrideWithValue(repository),
      locationServiceProvider.overrideWithValue(
        location ?? FakeLocationService(),
      ),
    ],
  );

  Future<AsyncValue<Weather>> settle(ProviderContainer c) async {
    c.listen(weatherControllerProvider, (_, _) {});
    try {
      await c.read(weatherControllerProvider.future);
    } catch (_) {
      // checked through the state
    }
    return c.read(weatherControllerProvider);
  }

  test('the weather is saved, per place', () async {
    final storage = Storage<String, String>.inMemory();
    await settle(container(online(), storage));

    final saved = await storage.read('weather_here');
    final weather = Weather.fromJson(
      jsonDecode(saved!.data) as Map<String, dynamic>,
    );
    expect(weather.place, 'Yangon');
  });

  test('the saved weather shows while the new one loads', () async {
    final pending = Completer<Weather>();
    final c = container(
      FakeWeatherRepository((_, _) => pending.future),
      await savedHere(),
    );
    c.listen(weatherControllerProvider, (_, _) {});
    await pumpEventQueue();

    final state = c.read(weatherControllerProvider);
    expect(state.isLoading, isTrue);
    expect(state.isFromCache, isTrue);
    expect(state.value?.place, 'Yangon');
    pending.complete(await fixtureRepository().getWeather(lat: 0, lon: 0));
  });

  test('offline: the saved weather stays, marked as stale', () async {
    final storage = await savedHere();
    final state = await settle(container(offline(), storage));

    expect(state, isA<AsyncData<Weather>>());
    expect(state.value!.isStale, isTrue);
    expect(await storage.read('weather_here'), isNotNull); // not deleted
  });

  test("another place's saved weather is never shown", () async {
    final c = container(offline(), await savedHere());
    await c.read(selectedPlaceProvider.future);
    c.read(selectedPlaceProvider.notifier).select(mandalay);

    expect((await settle(c)).error, isA<AppException>());
  });

  test('a location problem shows its error, even with saved weather', () async {
    final location = FakeLocationService(
      () async => throw const AppException(
        'Location is turned off.',
        kind: ErrorKind.locationOff,
      ),
    );
    final state = await settle(
      container(online(), await savedHere(), location: location),
    );
    expect((state.error! as AppException).kind, ErrorKind.locationOff);
  });

  test('the picked city is remembered for the next launch', () async {
    final storage = Storage<String, String>.inMemory();
    final first = container(online(), storage);
    await first.read(selectedPlaceProvider.future);
    first.read(selectedPlaceProvider.notifier).select(mandalay);
    await settle(first);

    // A new container is like opening the app again.
    final location = FakeLocationService();
    final second = container(online(), storage, location: location);
    final state = await settle(second);

    expect(state.value?.place, 'Mandalay');
    expect(location.positionCalls, 0);
  });

  test('a city picked while the first weather loads never gets the '
      'saved weather of "where I am"', () async {
    final pendingHere = Completer<Weather>();
    final storage = await savedHere();
    final c = container(
      FakeWeatherRepository(
        (lat, lon) => lat == yangon.lat
            ? pendingHere.future
            : throw const AppException(
                'Unable to connect.',
                kind: ErrorKind.network,
              ),
      ),
      storage,
    );
    c.listen(weatherControllerProvider, (_, _) {});
    await pumpEventQueue();
    expect(c.read(weatherControllerProvider).isFromCache, isTrue);

    c.read(selectedPlaceProvider.notifier).select(mandalay);
    final state = await settle(c);

    expect(state.error, isA<AppException>());
    expect(
      await storage.read('weather_${mandalay.lat}_${mandalay.lon}'),
      isNull,
    );
    pendingHere.complete(await fixtureRepository().getWeather(lat: 0, lon: 0));
  });

  test(
    'an outdated request finishing late does not break the fallback',
    () async {
      final pendingHere = Completer<Weather>();
      var offline = false;
      final c = container(
        FakeWeatherRepository((lat, lon) async {
          if (lat == yangon.lat) return pendingHere.future;
          if (offline) {
            throw const AppException(
              'Unable to connect.',
              kind: ErrorKind.network,
            );
          }
          return fixtureRepository().getWeather(lat: lat, lon: lon);
        }),
        Storage<String, String>.inMemory(),
      );
      c.listen(weatherControllerProvider, (_, _) {});
      await pumpEventQueue(); // "where I am" is loading

      c.read(selectedPlaceProvider.notifier).select(mandalay);
      expect((await settle(c)).value?.place, 'Mandalay');

      // The request for "where I am" finishes now, after Mandalay's.
      pendingHere.complete(
        await fixtureRepository().getWeather(lat: 0, lon: 0),
      );
      await pumpEventQueue();

      offline = true;
      await c.read(weatherControllerProvider.notifier).refresh();
      final state = c.read(weatherControllerProvider);
      expect(state.value?.place, 'Mandalay');
      expect(state.value?.isStale, isTrue);
    },
  );

  group('updatedAgo', () {
    final fetched = DateTime.utc(2026, 10, 28, 4, 30);
    String at(Duration later) => updatedAgo(fetched, fetched.add(later));

    test('minutes, hours, then the date', () {
      expect(at(const Duration(seconds: 20)), 'Updated just now');
      expect(at(const Duration(minutes: 5)), 'Updated 5 min ago');
      expect(at(const Duration(hours: 2, minutes: 10)), 'Updated 2 h ago');
      expect(at(const Duration(days: 3)), startsWith('Updated Oct'));
    });
  });

  testWidgets('the stale notice and how old the weather is', (tester) async {
    final storage = await tester.runAsync(savedHere);
    await tester.pumpWidget(
      ProviderScope(
        retry: noRetry,
        overrides: [
          ...deviceOverrides(storage: storage),
          weatherRepositoryProvider.overrideWithValue(offline()),
          locationServiceProvider.overrideWithValue(FakeLocationService()),
        ],
        child: const BreezeApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Updated 2 h ago'), findsOneWidget);
    expect(find.textContaining("Couldn't load new weather"), findsOneWidget);
    expect(find.text('Yangon, MM'), findsOneWidget);
  });
}
