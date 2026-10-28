import 'package:breeze/app.dart';
import 'package:breeze/core/app_exception.dart';
import 'package:breeze/core/retry_policy.dart';
import 'package:breeze/providers/weather_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_weather_repository.dart';

void main() {
  Widget appWith(FakeWeatherRepository repository) => ProviderScope(
    retry: noRetry, // show errors right away
    overrides: [weatherRepositoryProvider.overrideWithValue(repository)],
    child: const BreezeApp(),
  );

  testWidgets('shows the weather in Yangon', (tester) async {
    final repository = FakeWeatherRepository(
      (lat, lon) => fixtureRepository().getWeather(lat: lat, lon: lon),
    );
    await tester.pumpWidget(appWith(repository));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('Yangon, MM'), findsOneWidget);
    expect(find.text('29°C'), findsOneWidget);
    expect(find.text('light rain'), findsWidgets);
    expect(repository.calls, [(yangon.lat, yangon.lon)]);
    // The first step is 06:00 UTC = 12:30 in Yangon.
    expect(find.text('12:30'), findsOneWidget);
  });

  testWidgets('an error can be retried', (tester) async {
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
}
