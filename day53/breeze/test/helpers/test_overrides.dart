import 'package:breeze/providers/weather_providers.dart';
import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

/// "Now" in tests: 5 minutes after fixtureRepository() fetched.
final testNow = DateTime.utc(2026, 10, 28, 4, 35);

/// No SQLite and a fixed clock: what every test needs from the device.
List<Override> deviceOverrides({Storage<String, String>? storage}) => [
  storageProvider.overrideWith(
    (ref) => storage ?? Storage<String, String>.inMemory(),
  ),
  clockProvider.overrideWithValue(() => testNow),
];
