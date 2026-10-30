import 'dart:math';

/// A point on Earth, in degrees.
typedef LatLng = ({double latitude, double longitude});

/// The mean radius of the Earth, in meters.
const earthRadius = 6371000.0;

/// The distance between two points along the Earth's surface, in meters
/// (Day 82): the haversine formula, which treats the Earth as a sphere.
/// Good to a few meters per kilometer, plenty for "what's near me".
double distanceMeters(LatLng a, LatLng b) {
  double rad(double degrees) => degrees * pi / 180;
  final dLat = rad(b.latitude - a.latitude);
  final dLon = rad(b.longitude - a.longitude);
  final h =
      pow(sin(dLat / 2), 2) +
      cos(rad(a.latitude)) * cos(rad(b.latitude)) * pow(sin(dLon / 2), 2);
  return 2 * earthRadius * asin(sqrt(h));
}

/// "350 m", "1.2 km", "15 km": how far, as people say it.
String formatDistance(double meters) => switch (meters) {
  // 995 m would round to "1000 m": that's "1.0 km".
  < 995 => '${(meters / 10).round() * 10} m',
  < 9950 => '${(meters / 1000).toStringAsFixed(1)} km',
  _ => '${(meters / 1000).round()} km',
};
