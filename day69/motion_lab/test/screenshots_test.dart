// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';
import 'package:motion_lab/main.dart';

import 'helpers/rive_helper.dart';
import 'helpers/screenshot_helper.dart';

/// Screenshots for the blog post (written to test/screenshots/).
void main() {
  setUpAll(loadRealFonts);
  useFlutterRenderer();

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

  testWidgets(
    'day69_rating',
    (t) => screenshot(
      t,
      'day69_rating',
      const MotionLabApp(),
      settle: false,
      before: (t) async {
        await openRiveDemo(t, 'Rating');
        final box = t.getRect(find.byType(RiveWidget));
        await t.tapAt(
          Offset(box.left + box.width * 0.64, box.top + box.height * 0.49),
        );
        await runFrames(t, 60);
      },
    ),
  );

  testWidgets(
    'day69_rewards',
    (t) => screenshot(
      t,
      'day69_rewards',
      const MotionLabApp(),
      settle: false,
      before: (t) async {
        await openRiveDemo(t, 'Rewards');
        await runFrames(t, 5);
        await t.tap(find.text('+100 coins'));
        await t.tap(find.text('+100 coins'));
        await runFrames(t, 60);
      },
    ),
  );
}
