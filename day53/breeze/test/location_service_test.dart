import 'dart:async';

import 'package:breeze/core/app_exception.dart';
import 'package:breeze/data/location/location_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

/// Stands in for the platform code that the Geolocator class calls.
class FakeGeolocatorPlatform extends GeolocatorPlatform {
  FakeGeolocatorPlatform({
    this.serviceEnabled = true,
    this.permission = LocationPermission.whileInUse,
    this.afterRequest = LocationPermission.whileInUse,
    this.position,
    this.lastKnown,
    this.positionError,
  });

  bool serviceEnabled;
  LocationPermission permission;
  LocationPermission afterRequest;
  Position? position; // null: times out
  Position? lastKnown;
  Exception? positionError; // thrown by getCurrentPosition
  int requests = 0;
  LocationSettings? settings;

  @override
  Future<bool> isLocationServiceEnabled() async => serviceEnabled;

  @override
  Future<LocationPermission> checkPermission() async => permission;

  @override
  Future<LocationPermission> requestPermission() async {
    requests++;
    return permission = afterRequest;
  }

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    settings = locationSettings;
    if (positionError != null) throw positionError!;
    if (position == null) throw TimeoutException('no fix');
    return position!;
  }

  @override
  Future<Position?> getLastKnownPosition({
    bool forceLocationManager = false,
  }) async => lastKnown;
}

final now = DateTime.utc(2026, 10, 28, 12);

Position at(double lat, double lon, {DateTime? time}) => Position(
  latitude: lat,
  longitude: lon,
  timestamp: time ?? now,
  accuracy: 1000,
  altitude: 0,
  altitudeAccuracy: 0,
  heading: 0,
  headingAccuracy: 0,
  speed: 0,
  speedAccuracy: 0,
);

GeolocatorLocationService service(GeolocatorPlatform platform) =>
    GeolocatorLocationService(platform: platform, now: () => now);

void main() {
  Future<ErrorKind?> kindOf(FakeGeolocatorPlatform platform) async {
    try {
      await service(platform).currentPosition();
      return null;
    } on AppException catch (e) {
      return e.kind;
    }
  }

  test('allowed: returns the position, with low accuracy', () async {
    final platform = FakeGeolocatorPlatform(position: at(16.87, 96.2));
    final position = await service(platform).currentPosition();

    expect(position, (lat: 16.87, lon: 96.2));
    expect(platform.requests, 0); // already allowed: no dialog
    expect(platform.settings?.accuracy, LocationAccuracy.low);
  });

  test('location turned off', () async {
    expect(
      await kindOf(FakeGeolocatorPlatform(serviceEnabled: false)),
      ErrorKind.locationOff,
    );
  });

  test('not asked yet: asks, and the user allows it', () async {
    final platform = FakeGeolocatorPlatform(
      permission: LocationPermission.denied,
      position: at(1, 2),
    );
    expect(await kindOf(platform), isNull);
    expect(platform.requests, 1);
  });

  test('asks, and the user says no', () async {
    final platform = FakeGeolocatorPlatform(
      permission: LocationPermission.denied,
      afterRequest: LocationPermission.denied,
    );
    expect(await kindOf(platform), ErrorKind.locationDenied);
  });

  test('denied forever: does not ask again', () async {
    final platform = FakeGeolocatorPlatform(
      permission: LocationPermission.deniedForever,
    );
    expect(await kindOf(platform), ErrorKind.locationDeniedForever);
    expect(platform.requests, 0);
  });

  test('no fix in time: uses the last known position', () async {
    final platform = FakeGeolocatorPlatform(lastKnown: at(3, 4));
    expect(await service(platform).currentPosition(), (lat: 3.0, lon: 4.0));
  });

  test('no fix and no last known position', () async {
    expect(
      await kindOf(FakeGeolocatorPlatform()),
      ErrorKind.locationUnavailable,
    );
  });

  test('Android: denied forever only shows when asking', () async {
    final platform = FakeGeolocatorPlatform(
      permission: LocationPermission.denied,
      afterRequest: LocationPermission.deniedForever,
    );
    expect(await kindOf(platform), ErrorKind.locationDeniedForever);
    expect(platform.requests, 1);
  });

  test('an old last known position is not used', () async {
    final platform = FakeGeolocatorPlatform(
      lastKnown: at(3, 4, time: now.subtract(const Duration(hours: 2))),
    );
    expect(await kindOf(platform), ErrorKind.locationUnavailable);
  });

  test("the plugin's own exceptions get the right kind", () async {
    Future<ErrorKind?> kindFor(Exception e) =>
        kindOf(FakeGeolocatorPlatform(positionError: e));

    expect(
      await kindFor(const LocationServiceDisabledException()),
      ErrorKind.locationOff,
    );
    expect(
      await kindFor(const PermissionDeniedException('no')),
      ErrorKind.locationDenied,
    );
    expect(
      await kindFor(const PositionUpdateException('failed')),
      ErrorKind.locationUnavailable,
    );
  });
}
