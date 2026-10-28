import 'package:breeze/data/location/location_service.dart';

/// Yangon, for tests that don't care where they are.
const yangon = (lat: 16.8713, lon: 96.1994);

/// A LocationService whose answer is decided by the test.
class FakeLocationService implements LocationService {
  FakeLocationService([Future<Coordinates> Function()? onPosition])
    : onPosition = onPosition ?? (() async => yangon);

  Future<Coordinates> Function() onPosition;
  int positionCalls = 0;
  int locationSettingsOpened = 0;
  int appSettingsOpened = 0;

  @override
  Future<Coordinates> currentPosition() {
    positionCalls++;
    return onPosition();
  }

  @override
  Future<bool> openLocationSettings() async {
    locationSettingsOpened++;
    return true;
  }

  @override
  Future<bool> openAppSettings() async {
    appSettingsOpened++;
    return true;
  }
}
