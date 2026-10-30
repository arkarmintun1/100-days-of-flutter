import 'dart:async';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';

import '../../domain/distance.dart';
import '../../domain/failures.dart';
import '../../domain/nearby.dart';

/// The phone's position with the geolocator package: Breeze's location
/// service from Day 50, with Trip Buddy's failures.
class GeolocatorLocationService implements LocationService {
  GeolocatorLocationService({
    GeolocatorPlatform? platform,
    DateTime Function()? now,
  }) : _platform = platform ?? GeolocatorPlatform.instance,
       _now = now ?? DateTime.now;

  /// What the Geolocator class calls under the hood. Tests pass a fake.
  final GeolocatorPlatform _platform;
  final DateTime Function() _now;

  /// "Which café is closest" needs better than city-level (Breeze's
  /// weather was fine with low accuracy).
  static const _settings = LocationSettings(
    accuracy: LocationAccuracy.high,
    timeLimit: Duration(seconds: 15),
  );

  /// A walk's worth: an older last known position may be blocks away.
  static const maxLastKnownAge = Duration(minutes: 5);

  static const _off = LocationFailure(
    'Location is turned off. Turn it on to see what is near you.',
    fix: LocationFix.turnOnLocation,
  );
  static const _denied = LocationFailure(
    'Trip Buddy needs your location to find what is near you.',
  );
  static const _deniedForever = LocationFailure(
    'Location access is off for Trip Buddy. Allow it in the app settings.',
    fix: LocationFix.allowInAppSettings,
  );
  static const _unavailable = LocationFailure(
    "Couldn't find your location. Please try again.",
  );

  @override
  Future<LatLng> currentPosition() async {
    try {
      return await _position();
    } on Failure {
      rethrow;
    } on Exception catch (e) {
      // Anything else from the plugin, e.g. PermissionDefinitionsNotFound-
      // Exception when the AndroidManifest / Info.plist entries (Setup)
      // are missing.
      log('Getting the location failed', error: e);
      throw _unavailable;
    }
  }

  Future<LatLng> _position() async {
    // 1. Is location turned on at all?
    if (!await _platform.isLocationServiceEnabled()) throw _off;

    // 2. May we use it? Ask if we haven't yet (Day 50: on Android only
    // requestPermission() answers `deniedForever`).
    var permission = await _platform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _platform.requestPermission();
    }
    switch (permission) {
      case LocationPermission.denied:
        throw _denied;
      case LocationPermission.deniedForever:
        throw _deniedForever;
      case LocationPermission.whileInUse ||
          LocationPermission.always ||
          LocationPermission.unableToDetermine:
        break;
    }

    // 3. Where are we?
    try {
      final position = await _platform.getCurrentPosition(
        locationSettings: _settings,
      );
      return (latitude: position.latitude, longitude: position.longitude);
    } on TimeoutException {
      // No fix in time (e.g. indoors): a recent last known position will do.
      final last = await _recentLastKnownPosition();
      if (last != null) {
        return (latitude: last.latitude, longitude: last.longitude);
      }
      throw _unavailable;
    } on LocationServiceDisabledException {
      throw _off; // turned off after step 1
    } on PermissionDeniedException {
      throw _denied; // taken away after step 2
    } on PositionUpdateException {
      throw _unavailable;
    }
  }

  Future<Position?> _recentLastKnownPosition() async {
    final Position? last;
    try {
      last = await _platform.getLastKnownPosition();
    } on Exception {
      return null; // e.g. the permission was taken away meanwhile
    }
    if (last == null) return null;
    return _now().difference(last.timestamp) <= maxLastKnownAge ? last : null;
  }

  @override
  Future<bool> openLocationSettings() => _platform.openLocationSettings();

  @override
  Future<bool> openAppSettings() => _platform.openAppSettings();
}
