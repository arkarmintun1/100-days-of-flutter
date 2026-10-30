import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trip_buddy/data/location/geolocator_location_service.dart';
import 'package:trip_buddy/domain/failures.dart';

/// Location is on, not yet allowed, and asking throws what the plugin
/// throws when the AndroidManifest / Info.plist entries are missing.
class _NoPermissionEntries extends GeolocatorPlatform {
  @override
  Future<bool> isLocationServiceEnabled() async => true;

  @override
  Future<LocationPermission> checkPermission() async =>
      LocationPermission.denied;

  @override
  Future<LocationPermission> requestPermission() async =>
      throw const PermissionDefinitionsNotFoundException('No entries.');
}

void main() {
  test('a plugin error is a LocationFailure, not a crash', () async {
    final service = GeolocatorLocationService(platform: _NoPermissionEntries());

    await expectLater(
      service.currentPosition(),
      throwsA(isA<LocationFailure>()),
    );
  });
}
