import 'package:breeze/app.dart';
import 'package:breeze/core/app_exception.dart';
import 'package:breeze/core/retry_policy.dart';
import 'package:breeze/providers/weather_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_location_service.dart';
import 'helpers/fake_weather_repository.dart';
import 'helpers/test_overrides.dart';

void main() {
  Widget appWith(
    FakeWeatherRepository repository, {
    FakeLocationService? location,
  }) => ProviderScope(
    retry: noRetry, // show errors right away
    overrides: [
      ...deviceOverrides(),
      weatherRepositoryProvider.overrideWithValue(repository),
      locationServiceProvider.overrideWithValue(
        location ?? FakeLocationService(),
      ),
    ],
    child: const BreezeApp(),
  );

  FakeWeatherRepository fixtures() => FakeWeatherRepository(
    (lat, lon) => fixtureRepository().getWeather(lat: lat, lon: lon),
  );

  testWidgets('shows the weather where the device is', (tester) async {
    final repository = fixtures();
    await tester.pumpWidget(appWith(repository));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('Yangon, MM'), findsOneWidget);
    expect(find.text('29°'), findsWidgets);
    expect(find.text('Light rain'), findsOneWidget);
    expect(repository.calls, [(yangon.lat, yangon.lon)]);
    // The first step is 06:00 UTC = 12:30 in Yangon.
    expect(find.text('12:30'), findsOneWidget);
  });

  testWidgets('a network error can be retried', (tester) async {
    var fail = true;
    final repository = FakeWeatherRepository((lat, lon) async {
      if (fail) {
        throw const AppException('Unable to connect.', kind: ErrorKind.network);
      }
      return fixtureRepository().getWeather(lat: lat, lon: lon);
    });
    await tester.pumpWidget(appWith(repository));
    await tester.pumpAndSettle();
    expect(find.text('Unable to connect.'), findsOneWidget);

    fail = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Yangon, MM'), findsOneWidget);
  });

  testWidgets('location turned off: a button opens the location settings', (
    tester,
  ) async {
    final location = FakeLocationService(
      () async => throw const AppException(
        'Location is turned off.',
        kind: ErrorKind.locationOff,
      ),
    );
    final repository = fixtures();
    await tester.pumpWidget(appWith(repository, location: location));
    await tester.pumpAndSettle();

    expect(find.text('Location is turned off.'), findsOneWidget);
    expect(repository.calls, isEmpty); // no position, no weather request
    await tester.tap(find.text('Open location settings'));
    expect(location.locationSettingsOpened, 1);
    expect(find.text('Open app settings'), findsNothing);
  });

  testWidgets('denied forever: a button opens the app settings', (
    tester,
  ) async {
    final location = FakeLocationService(
      () async => throw const AppException(
        'Allow location in the app settings.',
        kind: ErrorKind.locationDeniedForever,
      ),
    );
    await tester.pumpWidget(appWith(fixtures(), location: location));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open app settings'));
    expect(location.appSettingsOpened, 1);
  });

  testWidgets('"Try again" asks for the position again', (tester) async {
    var allowed = false;
    final location = FakeLocationService(() async {
      if (!allowed) {
        throw const AppException(
          'Breeze needs your location.',
          kind: ErrorKind.locationDenied,
        );
      }
      return yangon;
    });
    await tester.pumpWidget(appWith(fixtures(), location: location));
    await tester.pumpAndSettle();
    expect(location.positionCalls, 1);

    allowed = true; // the user allows it this time
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(location.positionCalls, 2);
    expect(find.text('Yangon, MM'), findsOneWidget);
  });

  testWidgets('no location? search for a city instead', (tester) async {
    final location = FakeLocationService(
      () async => throw const AppException(
        'Breeze needs your location.',
        kind: ErrorKind.locationDenied,
      ),
    );
    final repository = fixtures();
    await tester.pumpWidget(appWith(repository, location: location));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Search for a city'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Mandalay');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(repository.searches, ['Mandalay']);

    await tester.tap(find.text('Mandalay, MM'));
    await tester.pumpAndSettle();

    // Back on the weather screen, with Mandalay's weather.
    expect(find.text('Mandalay, MM'), findsOneWidget);
    expect(repository.calls, [(mandalay.lat, mandalay.lon)]);
    expect(find.byTooltip('My location'), findsOneWidget);
  });

  testWidgets("back to my location, but it's denied: the error, not the "
      "city's weather", (tester) async {
    final location = FakeLocationService(
      () async => throw const AppException(
        'Breeze needs your location.',
        kind: ErrorKind.locationDenied,
      ),
    );
    await tester.pumpWidget(appWith(fixtures(), location: location));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Search for a city'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Mandalay');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mandalay, MM'));
    await tester.pumpAndSettle();
    expect(find.text('Mandalay, MM'), findsOneWidget);

    await tester.tap(find.byTooltip('My location'));
    await tester.pumpAndSettle();
    // The state is an AsyncError that still holds Mandalay's weather.
    expect(find.text('Breeze needs your location.'), findsOneWidget);
    expect(find.text('Mandalay, MM'), findsNothing);
  });
}
