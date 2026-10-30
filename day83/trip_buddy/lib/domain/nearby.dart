import 'distance.dart';
import 'trip_place.dart';

/// The phone's position (Day 82). Throws a LocationFailure.
abstract interface class LocationService {
  Future<LatLng> currentPosition();

  /// The system's location settings (to turn location on).
  Future<bool> openLocationSettings();

  /// This app's settings (to allow location after "don't ask again").
  Future<bool> openAppSettings();
}

/// Where the map's places are kept between app starts (Day 82), so the
/// map and "near me" don't ask Gemini again. Throws a StorageFailure.
abstract interface class PlaceStore {
  Future<List<TripPlace>> load();

  /// Replaces the saved places with these.
  Future<void> save(List<TripPlace> places);
}

/// A place and how far it is from the phone.
typedef NearbyPlace = ({TripPlace place, double meters});

/// The saved places, nearest first (Day 82). Throws a Failure.
class FindNearby {
  FindNearby(this._store, this._location);

  final PlaceStore _store;
  final LocationService _location;

  Future<List<NearbyPlace>> call({PlaceKind? kind, int? top}) async {
    final places = [
      for (final place in await _store.load())
        if (kind == null || place.found.kind == kind) place,
    ];
    // No places, no need to ask for the location (and its permission).
    if (places.isEmpty) return [];
    final here = await _location.currentPosition();
    final nearby = [
      for (final place in places)
        (
          place: place,
          meters: distanceMeters(here, (
            latitude: place.latitude,
            longitude: place.longitude,
          )),
        ),
    ]..sort((a, b) => a.meters.compareTo(b.meters));
    return top == null ? nearby : nearby.take(top).toList();
  }
}
