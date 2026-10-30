import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/domain/failures.dart';
import 'package:trip_buddy/domain/forecast.dart';

import '../helpers/fake_forecast.dart';
import '../helpers/fake_places.dart';

void main() {
  group('GetForecast', () {
    late FakeForecastService service;
    late FakeGeocoder geocoder;
    late DateTime now;
    late GetForecast forecast;

    setUp(() {
      service = FakeForecastService();
      geocoder = FakeGeocoder();
      now = DateTime(2026, 10, 29, 10);
      forecast = GetForecast(geocoder, service, now: () => now);
    });

    final from = DateTime(2026, 10, 31);
    final to = DateTime(2026, 11, 1);

    test('finds the place, then asks for its days', () async {
      final days = await forecast('Singapore', from, to);

      expect([for (final d in days) d.date.day], [31, 1]);
      expect(geocoder.asked, ['Singapore']);
      expect(service.calls.single, (latitude: 1.2897, longitude: 103.8501));
    });

    test('keeps an answer for 30 minutes, for the card', () async {
      final first = await forecast('Singapore', from, to);
      // The model's place and the card's may differ in case and spaces.
      expect(await forecast(' singapore ', from, to), same(first));
      expect(service.calls, hasLength(1));

      now = now.add(const Duration(minutes: 30));
      await forecast('Singapore', from, to);
      expect(service.calls, hasLength(2));
    });

    test("a failure isn't kept: the next try asks again", () async {
      service.error = const NetworkFailure(
        "Couldn't reach the weather service.",
      );
      await expectLater(
        forecast('Singapore', from, to),
        throwsA(isA<NetworkFailure>()),
      );

      service.error = null;
      expect(await forecast('Singapore', from, to), hasLength(2));
      expect(service.calls, hasLength(2));
    });

    test('checks the place and the days before any request', () async {
      await expectLater(
        forecast('Atlantis', from, to),
        throwsA(
          isA<ValidationFailure>().having(
            (f) => f.message,
            'message',
            'Couldn\'t find "Atlantis" on the map.',
          ),
        ),
      );
      await expectLater(
        forecast('Singapore', to, from),
        throwsA(isA<ValidationFailure>()),
      );
      // 16 days is the most: 31 Oct to 15 Nov is fine, to 16 Nov isn't.
      await forecast('Singapore', from, DateTime(2026, 11, 15));
      await expectLater(
        forecast('Singapore', from, DateTime(2026, 11, 16)),
        throwsA(isA<ValidationFailure>()),
      );
      expect(service.calls, hasLength(1));
    });
  });

  test('weatherText follows the WMO codes', () {
    expect(weatherText(0), 'Clear sky');
    expect(weatherText(53), 'Moderate drizzle');
    expect(weatherText(81), 'Moderate rain showers');
    expect(weatherText(97), 'Heavy thunderstorm');
    expect(weatherText(42), 'Unknown weather');
  });
}
