import 'package:flutter/material.dart';
import 'package:trip_buddy/domain/trip_place.dart';

/// Finds prepared places in every document, for tests (Day 81).
class FakePlaceFinder implements PlaceFinder {
  FakePlaceFinder([this.places = singaporePlaces]);

  final List<({String name, PlaceKind kind, String address})> places;
  final calls = <({String title, String text})>[];

  @override
  Future<List<FoundPlace>> find({
    required String title,
    required String text,
  }) async {
    calls.add((title: title, text: text));
    return [
      for (final p in places)
        FoundPlace(
          name: p.name,
          kind: p.kind,
          address: p.address,
          documentTitle: title,
        ),
    ];
  }

  static const singaporePlaces = [
    (
      name: 'Parkroyal Collection Pickering',
      kind: PlaceKind.hotel,
      address: '3 Upper Pickering Street, Singapore',
    ),
    (
      name: 'Maxwell Food Centre',
      kind: PlaceKind.food,
      address: '1 Kadayanallur Street, Singapore',
    ),
    (
      name: 'Gardens by the Bay',
      kind: PlaceKind.sight,
      address: '18 Marina Gardens Drive, Singapore',
    ),
    (
      name: 'Changi Airport Terminal 3',
      kind: PlaceKind.airport,
      address: 'Changi Airport Terminal 3, Singapore',
    ),
  ];
}

/// Coordinates from a table; anything else isn't found.
class FakeGeocoder implements Geocoder {
  FakeGeocoder([this.points = singaporePoints]);

  final Map<String, (double, double)> points;
  final asked = <String>[];

  @override
  Future<({double latitude, double longitude})?> locate(String address) async {
    asked.add(address);
    final point = points[address];
    return point == null ? null : (latitude: point.$1, longitude: point.$2);
  }

  /// Approximate, for tests and screenshots only.
  static const singaporePoints = {
    '3 Upper Pickering Street, Singapore': (1.2856, 103.8467),
    '1 Kadayanallur Street, Singapore': (1.2804, 103.8448),
    '18 Marina Gardens Drive, Singapore': (1.2816, 103.8636),
    // Day 84: the city, for the weather.
    'Singapore': (1.2897, 103.8501),
  };
}

/// Stands in for Google Maps in widget tests: shows which place is
/// selected, so a test can check it.
Widget fakePlacesMap(List<TripPlace> places, TripPlace? selected) => ColoredBox(
  color: const Color(0xFFDDE6EE),
  child: Center(
    child: Text(
      selected == null
          ? 'Map: ${places.length} places'
          : 'Map: ${selected.found.name}',
    ),
  ),
);
