// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/screenshot_helper.dart';
import 'helpers/test_app.dart';

/// Screenshots for the blog posts (written to test/screenshots/).
void main() {
  setUpAll(loadRealFonts);

  testWidgets(
    'day75_search',
    (t) => screenshot(
      t,
      'day75_search',
      testApp(),
      before: (t) async {
        await t.enterText(find.byType(TextField), 'Where do I sleep?');
        await t.tap(find.byTooltip('Search'));
        await t.pumpAndSettle();
      },
    ),
  );
}
