import 'dart:async';

import 'package:breeze/core/app_exception.dart';
import 'package:breeze/core/retry_policy.dart';
import 'package:breeze/models/weather.dart';
import 'package:breeze/providers/weather_controller.dart';
import 'package:breeze/providers/weather_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_location_service.dart';
import 'helpers/fake_weather_repository.dart';
import 'helpers/test_overrides.dart';

void main() {
  late FakeWeatherRepository repository;
  late FakeLocationService location;

  ProviderContainer container() => ProviderContainer.test(
    retry: noRetry,
    overrides: [
      ...deviceOverrides(),
      weatherRepositoryProvider.overrideWithValue(repository),
      locationServiceProvider.overrideWithValue(location),
    ],
  );

  setUp(() {
    repository = FakeWeatherRepository(
      (lat, lon) => fixtureRepository().getWeather(lat: lat, lon: lon),
    );
    location = FakeLocationService();
  });

  Future<AsyncValue<Weather>> settle(ProviderContainer c) async {
    c.listen(weatherControllerProvider, (_, _) {});
    try {
      await c.read(weatherControllerProvider.future);
    } catch (_) {
      // checked through the state
    }
    return c.read(weatherControllerProvider);
  }

  test('no city picked: the weather where the device is', () async {
    final c = container();
    final state = await settle(c);

    expect(location.positionCalls, 1);
    expect(repository.calls, [(yangon.lat, yangon.lon)]);
    expect(state.value?.place, 'Yangon');
  });

  test('a picked city: its weather, without asking for the location', () async {
    final c = container();
    c.read(selectedPlaceProvider.notifier).select(mandalay);
    final state = await settle(c);

    expect(location.positionCalls, 0);
    expect(repository.calls, [(mandalay.lat, mandalay.lon)]);
    // The fixture says "Yangon"; the picked name wins.
    expect(state.value?.place, 'Mandalay');
  });

  test('picking a city when the location was denied fixes the error', () async {
    location.onPosition = () async => throw const AppException(
      'Breeze needs your location.',
      kind: ErrorKind.locationDenied,
    );
    final c = container();
    expect((await settle(c)).error, isA<AppException>());

    c.read(selectedPlaceProvider.notifier).select(mandalay);
    final state = await settle(c);
    expect(state.value?.place, 'Mandalay');
  });

  test('"My location" goes back to the device position', () async {
    final c = container();
    c.read(selectedPlaceProvider.notifier).select(mandalay);
    await settle(c);

    c.read(selectedPlaceProvider.notifier).useMyLocation();
    await settle(c);
    expect(repository.calls.last, (yangon.lat, yangon.lon));
  });

  test('refresh keeps the old weather on screen while loading', () async {
    Completer<Weather>? pending;
    repository = FakeWeatherRepository(
      (lat, lon) =>
          pending?.future ?? fixtureRepository().getWeather(lat: lat, lon: lon),
    );
    final c = container();
    await settle(c);

    pending = Completer<Weather>();
    final refresh = c.read(weatherControllerProvider.notifier).refresh();
    final state = c.read(weatherControllerProvider);
    expect(state.isLoading, isTrue);
    expect(state.value?.place, 'Yangon'); // still the old weather

    pending.complete(await fixtureRepository().getWeather(lat: 0, lon: 0));
    await refresh;
    expect(repository.calls, hasLength(2));
    expect(c.read(weatherControllerProvider).isLoading, isFalse);
  });

  test('picking a city while the location loads: the city wins', () async {
    final position = Completer<({double lat, double lon})>();
    location.onPosition = () => position.future;
    final c = container();
    c.listen(weatherControllerProvider, (_, _) {});

    c.read(selectedPlaceProvider.notifier).select(mandalay);
    final state = await settle(c);
    position.complete(yangon); // the old build finishes late
    await pumpEventQueue();

    expect(state.value?.place, 'Mandalay');
    expect(c.read(weatherControllerProvider).value?.place, 'Mandalay');
    expect(repository.calls, [(mandalay.lat, mandalay.lon)]);
  });
}
