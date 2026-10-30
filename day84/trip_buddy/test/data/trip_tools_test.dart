import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/data/ai/trip_tools.dart';
import 'package:trip_buddy/domain/booking.dart';
import 'package:trip_buddy/domain/failures.dart';
import 'package:trip_buddy/domain/nearby.dart';
import 'package:trip_buddy/domain/trip_place.dart';

import '../helpers/fake_forecast.dart';
import '../helpers/fake_itinerary.dart';
import '../helpers/fake_location.dart';

void main() {
  // 30 Oct 2026, 12:15 UTC: 20:15 in Singapore (UTC+8), 18:45 in Yangon
  // (UTC+6:30).
  final now = DateTime.utc(2026, 10, 30, 12, 15);
  late FakeItinerary itinerary;
  late TripTools tools;
  late String home;
  late List<Booking> added;

  setUp(() {
    home = 'Asia/Yangon';
    itinerary = FakeItinerary();
    added = [];
    tools = TripTools(
      itinerary: itinerary,
      now: () => now,
      homeTimeZone: () async => home,
      forecast: fakeGetForecast(),
      nearby: FindNearby(FakePlaceStore(), FakeLocationService()),
    );
  });

  Future<Map<String, Object?>> run(String name, Map<String, Object?> args) =>
      tools.run(FunctionCall(name, args), added.add);

  test('get_local_time: the time in an IANA time zone', () async {
    expect(await run('get_local_time', {'time_zone': 'Asia/Singapore'}), {
      'time_zone': 'Asia/Singapore',
      'local_time': '2026-10-30 20:15',
      'utc_offset': '+08:00',
    });
    expect(
      (await run('get_local_time', {'time_zone': 'Asia/Yangon'}))['utc_offset'],
      '+06:30',
    );
  });

  test('a made-up time zone is an error for the model', () async {
    expect(await run('get_local_time', {'time_zone': 'Singapore Time'}), {
      'error': 'time_zone must be an IANA name.',
    });
  });

  test('add_booking saves it in the place\'s time zone', () async {
    final result = await run('add_booking', {
      'title': 'Flight TG404 to Bangkok',
      'kind': 'flight',
      'date': '2026-12-16',
      'time': '09:05',
      'time_zone': 'Asia/Singapore',
    });

    final booking = itinerary.bookings.single;
    expect(result, {'saved': true, 'id': booking.id});
    expect(booking.kind, BookingKind.flight);
    expect(booking.startsAt, DateTime(2026, 12, 16, 9, 5));
    expect(booking.timeZone, 'Asia/Singapore');
    expect(added, [booking]);
  });

  test('without a time zone, the phone\'s is used', () async {
    await run('add_booking', {
      'title': 'Dinner',
      'kind': 'activity',
      'date': '2026-12-14',
      'time': '19:30',
    });

    expect(itinerary.bookings.single.timeZone, 'Asia/Yangon');
  });

  test('wrong arguments are errors, and nothing is saved', () async {
    for (final args in [
      {'title': 'A', 'kind': 'cruise', 'date': '2026-12-14', 'time': '10:00'},
      {'title': 'A', 'kind': 'hotel', 'date': '2026-02-30', 'time': '10:00'},
      {'title': 'A', 'kind': 'hotel', 'date': '2026-12-14', 'time': '24:00'},
      {'title': ' ', 'kind': 'hotel', 'date': '2026-12-14', 'time': '10:00'},
      {'title': 'A', 'kind': 'hotel', 'date': '2026-12-14'},
    ]) {
      expect(
        await run('add_booking', args),
        contains('error'),
        reason: '$args',
      );
    }
    expect(itinerary.bookings, isEmpty);
  });

  test('at most ${TripTools.maxAddsPerMessage} bookings per message', () async {
    final results = await Future.wait([
      for (var i = 0; i < TripTools.maxAddsPerMessage + 1; i++)
        run('add_booking', {
          'title': 'Tour $i',
          'kind': 'activity',
          'date': '2026-12-15',
          'time': '10:00',
        }),
    ]);

    expect(results.where((r) => r.containsKey('error')), hasLength(1));
    expect(itinerary.bookings, hasLength(TripTools.maxAddsPerMessage));
  });

  test('every message says what "now" is on the phone', () async {
    expect(
      await tools.context(),
      "Now on the user's phone: 2026-10-30 18:45 (Asia/Yangon).",
    );
  });

  test('Day 82: places_near_me lists the nearest saved places', () async {
    final near = TripTools(
      itinerary: itinerary,
      now: () => now,
      homeTimeZone: () async => home,
      forecast: fakeGetForecast(),
      nearby: FindNearby(
        FakePlaceStore([
          testPlace('Gardens by the Bay', PlaceKind.sight, 1.2816, 103.8636),
          testPlace('Maxwell Food Centre', PlaceKind.food, 1.2804, 103.8448),
        ]),
        FakeLocationService(),
      ),
    );

    final result = await near.run(
      const FunctionCall('places_near_me', {'kind': 'food'}),
      added.add,
    );

    expect(result, {
      'places': [
        {
          'name': 'Maxwell Food Centre',
          'kind': 'food',
          'address': 'Maxwell Food Centre, Singapore',
          'distance': '450 m',
        },
      ],
    });
  });

  test('Day 82: no location is an error for the model', () async {
    final near = TripTools(
      itinerary: itinerary,
      now: () => now,
      homeTimeZone: () async => home,
      forecast: fakeGetForecast(),
      nearby: FindNearby(
        FakePlaceStore([
          testPlace('Maxwell Food Centre', PlaceKind.food, 1.2804, 103.8448),
        ]),
        FakeLocationService(
          error: const LocationFailure('Location is turned off.'),
        ),
      ),
    );

    expect(
      await near.run(const FunctionCall('places_near_me', {}), added.add),
      {'error': 'Location is turned off.'},
    );
  });

  test(
    'Day 84: get_forecast gives the days, with the weather in words',
    () async {
      expect(
        await run('get_forecast', {
          'place': 'Singapore',
          'from': '2026-10-31',
          'to': '2026-11-01',
        }),
        {
          'place': 'Singapore',
          'days': [
            {
              'date': '2026-10-31',
              'weather': 'Moderate drizzle',
              'max_c': 31.9,
              'min_c': 25.2,
              'rain_chance_percent': 96,
            },
            {
              'date': '2026-11-01',
              'weather': 'Moderate rain showers',
              'max_c': 30.1,
              'min_c': 23.9,
              'rain_chance_percent': 96,
            },
          ],
          'data_by': 'Open-Meteo.com',
        },
      );
    },
  );

  test('Day 84: get_forecast problems go back to the model', () async {
    expect(
      await run('get_forecast', {'place': 'Atlantis', 'from': '2026-10-31'}),
      {'error': 'Couldn\'t find "Atlantis" on the map.'},
    );
    expect(
      await run('get_forecast', {'place': 'Singapore', 'from': '31/10/2026'}),
      {'error': 'date must be YYYY-MM-DD.'},
    );
    expect(
      await run('get_forecast', {
        'place': 'Singapore',
        'from': '2026-10-31',
        'to': '2026-12-31',
      }),
      {'error': 'A forecast covers at most 16 days.'},
    );
  });

  test(
    "the phone's time zone is unknown: UTC, and the model is told",
    () async {
      home = 'Mars/Olympus';

      expect(
        await tools.context(),
        "Now: 2026-10-30 12:15 UTC. The phone's time zone is unknown.",
      );
      expect(
        await run('add_booking', {
          'title': 'Dinner',
          'kind': 'other',
          'date': '2026-12-13',
          'time': '19:00',
        }),
        {'error': "The phone's time zone is unknown: give time_zone."},
      );
      expect(itinerary.bookings, isEmpty);
    },
  );

  test('old time zone names some phones report are known too', () async {
    home = 'Asia/Rangoon'; // today's Asia/Yangon

    expect(
      await tools.context(),
      "Now on the user's phone: 2026-10-30 18:45 (Asia/Rangoon).",
    );
  });
}
