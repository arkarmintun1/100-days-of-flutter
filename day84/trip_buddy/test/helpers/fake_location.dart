import 'package:trip_buddy/domain/distance.dart';
import 'package:trip_buddy/domain/nearby.dart';
import 'package:trip_buddy/domain/trip_place.dart';

/// The phone "is" at [position], or can't say where (Day 82).
class FakeLocationService implements LocationService {
  FakeLocationService({this.position = chinatown, this.error});

  final LatLng position;
  final Object? error;
  var asked = 0;
  var openedAppSettings = false;

  /// Near Chinatown MRT station, Singapore (approximate).
  static const chinatown = (latitude: 1.2844, longitude: 103.8443);

  @override
  Future<LatLng> currentPosition() async {
    asked++;
    if (error case final error?) throw error;
    return position;
  }

  @override
  Future<bool> openLocationSettings() async => true;

  @override
  Future<bool> openAppSettings() async => openedAppSettings = true;
}

/// Saved places in a list.
class FakePlaceStore implements PlaceStore {
  FakePlaceStore([List<TripPlace> places = const []])
    : places = List.of(places);

  List<TripPlace> places;

  @override
  Future<List<TripPlace>> load() async => List.of(places);

  @override
  Future<void> save(List<TripPlace> places) async =>
      this.places = List.of(places);
}

/// A place at [latitude], [longitude], for tests.
TripPlace testPlace(
  String name,
  PlaceKind kind,
  double latitude,
  double longitude,
) => TripPlace(
  FoundPlace(
    name: name,
    kind: kind,
    address: '$name, Singapore',
    documentTitle: 'Trip plan',
  ),
  latitude: latitude,
  longitude: longitude,
);
