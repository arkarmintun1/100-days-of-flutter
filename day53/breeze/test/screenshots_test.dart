// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'dart:convert';

import 'package:breeze/app.dart';
import 'package:breeze/core/app_exception.dart';
import 'package:breeze/models/place.dart';
import 'package:breeze/models/weather.dart';
import 'package:breeze/providers/weather_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_location_service.dart';
import 'helpers/fake_weather_repository.dart';
import 'helpers/test_overrides.dart';
import 'helpers/screenshot_helper.dart';

/// Screenshots for the blog posts (written to test/screenshots/).
void main() {
  setUpAll(loadRealFonts);

  testWidgets(
    'day50_location_off',
    (t) => screenshot(
      t,
      'day50_location_off',
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          ...deviceOverrides(),
          weatherRepositoryProvider.overrideWithValue(fixtureRepository()),
          locationServiceProvider.overrideWithValue(
            FakeLocationService(
              () async => throw const AppException(
                'Location is turned off. Turn it on to see the weather '
                'where you are.',
                kind: ErrorKind.locationOff,
              ),
            ),
          ),
        ],
        child: const BreezeApp(),
      ),
    ),
  );

  testWidgets('day51_search', (t) async {
    // Example results to show the labels (the API returns up to 5).
    const springfields = [
      Place(
        name: 'Springfield',
        state: 'Illinois',
        country: 'US',
        lat: 0,
        lon: 0,
      ),
      Place(
        name: 'Springfield',
        state: 'Missouri',
        country: 'US',
        lat: 0,
        lon: 0,
      ),
      Place(
        name: 'Springfield',
        state: 'Massachusetts',
        country: 'US',
        lat: 0,
        lon: 0,
      ),
    ];
    await screenshot(
      t,
      'day51_search',
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          ...deviceOverrides(),
          weatherRepositoryProvider.overrideWithValue(
            FakeWeatherRepository(
              (lat, lon) => fixtureRepository().getWeather(lat: lat, lon: lon),
              onSearch: (_) async => springfields,
            ),
          ),
          locationServiceProvider.overrideWithValue(FakeLocationService()),
        ],
        child: const BreezeApp(),
      ),
      before: (t) async {
        await t.tap(find.byTooltip('Search for a city'));
        await t.pumpAndSettle();
        await t.enterText(find.byType(TextField), 'Springfield');
        await t.testTextInput.receiveAction(TextInputAction.search);
        await t.pumpAndSettle();
      },
    );
  });

  Widget appWith(Future<Weather> Function() weather) => ProviderScope(
    retry: (_, _) => null,
    overrides: [
      ...deviceOverrides(),
      weatherRepositoryProvider.overrideWithValue(
        FakeWeatherRepository((_, _) => weather()),
      ),
      locationServiceProvider.overrideWithValue(FakeLocationService()),
    ],
    child: const BreezeApp(),
  );

  testWidgets(
    'day52_weather',
    (t) => screenshot(
      t,
      'day52_weather',
      appWith(() => fixtureRepository().getWeather(lat: 0, lon: 0)),
    ),
  );

  testWidgets('day52_clear_night', (t) async {
    // The same data, with a clear night sky.
    Future<Weather> clearNight() async {
      final weather = await fixtureRepository().getWeather(lat: 0, lon: 0);
      return weather.copyWith.current.condition(
        code: 800,
        main: 'Clear',
        description: 'clear sky',
        icon: '01n',
      );
    }

    await screenshot(t, 'day52_clear_night', appWith(clearNight));
  });

  testWidgets('day53_stale', (t) async {
    // Saved 2 hours ago, and now the phone is offline.
    final storage = Storage<String, String>.inMemory();
    final saved = await t.runAsync(
      () => fixtureRepository().getWeather(lat: 0, lon: 0),
    );
    storage.write(
      'weather_here',
      jsonEncode(
        saved!
            .copyWith(fetchedAt: testNow.subtract(const Duration(hours: 2)))
            .toJson(),
      ),
      const StorageOptions(),
    );
    await screenshot(
      t,
      'day53_stale',
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          ...deviceOverrides(storage: storage),
          weatherRepositoryProvider.overrideWithValue(
            FakeWeatherRepository(
              (_, _) async => throw const AppException(
                'Unable to connect.',
                kind: ErrorKind.network,
              ),
            ),
          ),
          locationServiceProvider.overrideWithValue(FakeLocationService()),
        ],
        child: const BreezeApp(),
      ),
    );
  });
}
