// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:breeze/app.dart';
import 'package:breeze/core/app_exception.dart';
import 'package:breeze/providers/weather_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_location_service.dart';
import 'helpers/fake_weather_repository.dart';
import 'helpers/screenshot_helper.dart';

/// Screenshots for the blog posts (written to test/screenshots/).
void main() {
  setUpAll(loadRealFonts);

  testWidgets(
    'day50_location_off',
    (t) => screenshot(
      t,
      'day50_location_off',
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          weatherRepositoryProvider.overrideWithValue(fixtureRepository()),
          locationServiceProvider.overrideWithValue(
            FakeLocationService(
              () async => throw const AppException(
                'Location is turned off. Turn it on to see the weather '
                'where you are.',
                kind: ErrorKind.locationOff,
              ),
            ),
          ),
        ],
        child: const BreezeApp(),
      ),
    ),
  );
}
