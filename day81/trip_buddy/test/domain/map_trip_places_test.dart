import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/domain/failures.dart';
import 'package:trip_buddy/domain/map_trip_places.dart';
import 'package:trip_buddy/domain/trip_place.dart';

import '../helpers/fake_places.dart';
import '../helpers/fake_trip_memory.dart';

void main() {
  late FakeTripMemory memory;

  Future<void> add(String title, List<String> chunks) => memory.addDocument(
    title: title,
    addedAt: DateTime(2026, 10, 30),
    chunks: [for (final text in chunks) (text: text, vector: Float32List(1))],
  );

  setUp(() => memory = FakeTripMemory());

  test('each document is read once, as one text', () async {
    final finder = FakePlaceFinder();
    await add('Trip plan', ['Hotel: Parkroyal.', 'Food: Maxwell.']);
    await add('Booking', ['Parkroyal Collection Pickering.']);

    await MapTripPlaces(memory, finder, FakeGeocoder())();

    expect(
      finder.calls.map((c) => c.title),
      unorderedEquals(['Trip plan', 'Booking']),
    );
    final plan = finder.calls.firstWhere((c) => c.title == 'Trip plan');
    expect(plan.text, 'Hotel: Parkroyal.\nFood: Maxwell.\n');
  });

  test('a place in two documents is one marker; unknown addresses are '
      'listed apart', () async {
    final geocoder = FakeGeocoder();
    await add('Trip plan', ['...']);
    await add('Booking', ['...']);

    final map = await MapTripPlaces(memory, FakePlaceFinder(), geocoder)();

    // 4 places in each document, the same 4: asked once each.
    expect(geocoder.asked, hasLength(4));
    expect(map.placed.map((p) => p.found.name), [
      'Parkroyal Collection Pickering',
      'Maxwell Food Centre',
      'Gardens by the Bay',
    ]);
    expect(map.notFound.single.name, 'Changi Airport Terminal 3');
    expect(map.placed.first.latitude, 1.2856);
  });

  test(
    'a long document is cut at ${MapTripPlaces.maxChars} characters',
    () async {
      final finder = FakePlaceFinder(const []);
      await add('Guide', [for (var i = 0; i < 50; i++) 'x' * 600]);

      await MapTripPlaces(memory, finder, FakeGeocoder())();

      expect(
        finder.calls.single.text.length,
        lessThanOrEqualTo(MapTripPlaces.maxChars + 50),
      );
    },
  );

  test('no documents: nothing to read', () async {
    await expectLater(
      MapTripPlaces(memory, FakePlaceFinder(), FakeGeocoder())(),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('places without coordinates are kept apart, not dropped', () async {
    await add('Plan', ['...']);

    final map = await MapTripPlaces(
      memory,
      FakePlaceFinder(),
      FakeGeocoder(const {}),
    )();

    expect(map.placed, isEmpty);
    expect(map.notFound, hasLength(4));
    expect(map.notFound.first.kind, PlaceKind.hotel);
  });

  test('two documents with the same title are read apart', () async {
    final finder = FakePlaceFinder();
    await add('Booking', ['Parkroyal Collection Pickering.']);
    await add('Booking', ['Maxwell Food Centre.']);

    await MapTripPlaces(memory, finder, FakeGeocoder())();

    expect(finder.calls.map((c) => c.text), [
      'Parkroyal Collection Pickering.\n',
      'Maxwell Food Centre.\n',
    ]);
  });
}
