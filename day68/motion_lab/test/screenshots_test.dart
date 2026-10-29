// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:motion_lab/main.dart';

import 'helpers/screenshot_helper.dart';

/// Screenshots for the blog post (written to test/screenshots/).
void main() {
  setUpAll(loadRealFonts);

  Future<void> openDemo(WidgetTester t, String demo) async {
    await t.tap(find.text(demo));
    await t.pumpAndSettle();
  }

  testWidgets(
    'day67_magic_box',
    (t) => screenshot(
      t,
      'day67_magic_box',
      const MotionLabApp(),
      before: (t) async {
        await openDemo(t, 'Magic box');
        await t.tap(find.text('Tap me'));
        await t.pump();
        // Mid-animation: between the small square and the big circle.
        await t.pump(const Duration(milliseconds: 250));
      },
    ),
  );

  testWidgets(
    'day67_sidebar',
    (t) => screenshot(
      t,
      'day67_sidebar',
      const MotionLabApp(),
      before: (t) async {
        await openDemo(t, 'Sidebar');
        await t.tap(find.byTooltip('Open menu'));
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day68_gallery',
    (t) => screenshot(
      t,
      'day68_gallery',
      const MotionLabApp(),
      before: (t) => openDemo(t, 'Gallery'),
    ),
  );

  testWidgets(
    'day68_flight',
    (t) => screenshot(
      t,
      'day68_flight',
      const MotionLabApp(),
      before: (t) async {
        await openDemo(t, 'Gallery');
        await t.tap(find.text('Camera'));
        await t.pump();
        // Halfway: the picture is flying, the new page is fading in.
        await t.pump(const Duration(milliseconds: 160));
      },
    ),
  );

  testWidgets(
    'day68_detail',
    (t) => screenshot(
      t,
      'day68_detail',
      const MotionLabApp(),
      before: (t) async {
        await openDemo(t, 'Gallery');
        await t.tap(find.text('Camera'));
        await t.pumpAndSettle();
      },
    ),
  );
}
