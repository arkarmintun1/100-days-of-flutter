/// What kind of place it is (Day 81): picks the marker's color.
enum PlaceKind { hotel, food, sight, airport, station, other }

/// A place a document mentions, as the model read it: no coordinates yet.
class FoundPlace {
  const FoundPlace({
    required this.name,
    required this.kind,
    required this.address,
    required this.documentTitle,
  });

  final String name;
  final PlaceKind kind;

  /// As specific as the document allows, e.g. "3 Upper Pickering Street,
  /// Singapore".
  final String address;
  final String documentTitle;
}

/// A place on the map: what was found, and where it is.
class TripPlace {
  const TripPlace(
    this.found, {
    required this.latitude,
    required this.longitude,
  });

  final FoundPlace found;
  final double latitude;
  final double longitude;
}

/// Reads the places out of a document's text. Throws a Failure.
abstract interface class PlaceFinder {
  Future<List<FoundPlace>> find({required String title, required String text});
}

/// Address → coordinates (Day 81). Null when it can't be found.
abstract interface class Geocoder {
  Future<({double latitude, double longitude})?> locate(String address);
}
