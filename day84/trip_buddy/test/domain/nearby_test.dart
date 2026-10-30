import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/domain/distance.dart';
import 'package:trip_buddy/domain/nearby.dart';
import 'package:trip_buddy/domain/trip_place.dart';

import '../helpers/fake_location.dart';

void main() {
  group('distanceMeters', () {
    test('one degree along the equator is 2πR / 360', () {
      expect(
        distanceMeters(
          (latitude: 0, longitude: 0),
          (latitude: 0, longitude: 1),
        ),
        closeTo(111194.9, 0.1),
      );
    });

    test('the same point is 0; the order of the points does not matter', () {
      const a = (latitude: 1.2844, longitude: 103.8443);
      const b = (latitude: 1.2816, longitude: 103.8636);
      expect(distanceMeters(a, a), 0);
      expect(distanceMeters(a, b), distanceMeters(b, a));
    });
  });

  test('formatDistance rounds like people talk', () {
    expect(formatDistance(347), '350 m');
    expect(formatDistance(996), '1.0 km');
    expect(formatDistance(1234), '1.2 km');
    expect(formatDistance(15400), '15 km');
  });

  group('FindNearby', () {
    final hotel = testPlace('Parkroyal', PlaceKind.hotel, 1.2856, 103.8467);
    final food = testPlace('Maxwell', PlaceKind.food, 1.2804, 103.8448);
    final gardens = testPlace(
      'Gardens by the Bay',
      PlaceKind.sight,
      1.2816,
      103.8636,
    );

    test('nearest first, with distances', () async {
      final nearby = await FindNearby(
        FakePlaceStore([gardens, hotel, food]),
        FakeLocationService(),
      )();

      expect(nearby.map((n) => n.place.found.name), [
        'Parkroyal',
        'Maxwell',
        'Gardens by the Bay',
      ]);
      expect(nearby.first.meters, lessThan(nearby.last.meters));
    });

    test('only one kind, and only the top ones', () async {
      final nearby = await FindNearby(
        FakePlaceStore([gardens, hotel, food]),
        FakeLocationService(),
      )(kind: PlaceKind.food, top: 1);

      expect(nearby.single.place, food);
    });

    test('no saved places: the location is not even asked for', () async {
      final location = FakeLocationService();

      expect(await FindNearby(FakePlaceStore(), location)(), isEmpty);
      expect(location.asked, 0);
    });
  });
}
