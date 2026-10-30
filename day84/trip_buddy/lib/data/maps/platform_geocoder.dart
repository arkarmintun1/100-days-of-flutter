import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' as geo;

import '../../domain/trip_place.dart';

/// The phone's own geocoder (Day 81): Apple's on iOS, Google's on
/// Android. Free, no API key, but rate-limited.
class PlatformGeocoder implements Geocoder {
  PlatformGeocoder([geo.Geocoding? geocoding])
    : _geocoding = geocoding ?? geo.Geocoding();

  final geo.Geocoding _geocoding;

  @override
  Future<({double latitude, double longitude})?> locate(String address) async {
    try {
      // geocoding_android 5.1.0 ignores the error callback of Android 13+'s
      // geocoder: a failed lookup would never answer. Give up after 10 s.
      final locations = await _geocoding
          .locationFromAddress(address)
          .timeout(const Duration(seconds: 10));
      if (locations.isEmpty) return null;
      // The first is the best match (the package's documentation).
      final best = locations.first;
      return (latitude: best.latitude, longitude: best.longitude);
    } on PlatformException catch (e) {
      // An address the platform can't resolve, or the service failing
      // (the package's README: often its rate limit). Either way this
      // place goes in the "couldn't place" list; the others still work.
      log('Geocoding "$address" failed', error: e);
      return null;
    } on TimeoutException catch (e) {
      log('Geocoding "$address" timed out', error: e);
      return null;
    }
  }
}
