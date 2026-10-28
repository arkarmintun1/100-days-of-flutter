// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:breeze/app.dart';
import 'package:breeze/providers/weather_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_weather_repository.dart';
import 'helpers/screenshot_helper.dart';

/// Screenshots for the blog posts (written to test/screenshots/).
void main() {
  setUpAll(loadRealFonts);

  testWidgets(
    'day49_first_screen',
    (t) => screenshot(
      t,
      'day49_first_screen',
      ProviderScope(
        overrides: [
          weatherRepositoryProvider.overrideWithValue(fixtureRepository()),
        ],
        child: const BreezeApp(),
      ),
    ),
  );
}
