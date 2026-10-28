import 'dart:async';

import 'package:breeze/core/app_exception.dart';
import 'package:geolocator/geolocator.dart';

/// A position on Earth, in degrees.
typedef Coordinates = ({double lat, double lon});

/// Where the device is. The rest of the app only knows this interface, so
/// tests can pretend to be anywhere.
abstract interface class LocationService {
  /// The device's position, asking for permission if needed. Throws an
  /// AppException with a location ErrorKind when it can't.
  Future<Coordinates> currentPosition();

  /// Opens the system's location settings (to turn location on).
  Future<bool> openLocationSettings();

  /// Opens this app's settings (to allow location after "don't ask again").
  Future<bool> openAppSettings();
}

/// The real thing, using the geolocator package.
class GeolocatorLocationService implements LocationService {
  GeolocatorLocationService({
    GeolocatorPlatform? platform,
    DateTime Function()? now,
  }) : _platform = platform ?? GeolocatorPlatform.instance,
       _now = now ?? DateTime.now;

  /// What the Geolocator class calls under the hood. Tests pass a fake.
  final GeolocatorPlatform _platform;
  final DateTime Function() _now;

  /// City-level is plenty for weather and uses less battery.
  static const _settings = LocationSettings(
    accuracy: LocationAccuracy.low,
    timeLimit: Duration(seconds: 15),
  );

  /// An older last known position may be in another city by now.
  static const maxLastKnownAge = Duration(minutes: 30);

  @override
  Future<Coordinates> currentPosition() async {
    // 1. Is location turned on at all?
    if (!await _platform.isLocationServiceEnabled()) {
      throw const AppException(
        'Location is turned off. Turn it on to see the weather where you are.',
        kind: ErrorKind.locationOff,
      );
    }

    // 2. May we use it? Ask if we haven't yet (or the user said no before).
    // On Android, checkPermission() says `denied` even after "Don't ask
    // again"; only requestPermission() then answers `deniedForever`.
    var permission = await _platform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _platform.requestPermission();
    }
    switch (permission) {
      case LocationPermission.denied:
        throw const AppException(
          'Breeze needs your location to show the weather where you are.',
          kind: ErrorKind.locationDenied,
        );
      case LocationPermission.deniedForever:
        throw const AppException(
          'Location access is off for Breeze. Allow it in the app settings.',
          kind: ErrorKind.locationDeniedForever,
        );
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
      return (lat: position.latitude, lon: position.longitude);
    } on TimeoutException {
      // No fix in time (e.g. indoors): a recent last known position is good
      // enough for the weather.
      final last = await _recentLastKnownPosition();
      if (last != null) return (lat: last.latitude, lon: last.longitude);
      throw _unavailable;
    } on LocationServiceDisabledException {
      // Turned off after step 1.
      throw const AppException(
        'Location is turned off. Turn it on to see the weather where you are.',
        kind: ErrorKind.locationOff,
      );
    } on PermissionDeniedException {
      // Taken away after step 2.
      throw const AppException(
        'Breeze needs your location to show the weather where you are.',
        kind: ErrorKind.locationDenied,
      );
    } on PositionUpdateException {
      throw _unavailable;
    }
  }

  static const _unavailable = AppException(
    "Couldn't find your location. Please try again.",
    kind: ErrorKind.locationUnavailable,
  );

  Future<Position?> _recentLastKnownPosition() async {
    final Position? last;
    try {
      last = await _platform.getLastKnownPosition();
    } on UnsupportedError {
      return null; // not available on the web
    } on Exception {
      return null; // e.g. the permission was taken away meanwhile
    }
    if (last == null) return null;
    final age = _now().difference(last.timestamp);
    return age <= maxLastKnownAge ? last : null;
  }

  @override
  Future<bool> openLocationSettings() => _platform.openLocationSettings();

  @override
  Future<bool> openAppSettings() => _platform.openAppSettings();
}
