import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';
import 'package:motion_lab/rive_factory.dart';

/// flutter test has no GPU: draw with Flutter's canvas instead of Rive's
/// renderer. Needs Rive's native library on this machine, once:
/// `dart run rive_native:setup --platform macos` (or linux / windows).
void useFlutterRenderer() {
  setUp(() => riveFactory = Factory.flutter);
  tearDown(() => riveFactory = Factory.rive);
}

/// Opens a demo from the home list. Not pumpAndSettle: a Rive animation can
/// keep running, so the screen may never "settle".
Future<void> openRiveDemo(WidgetTester tester, String title) async {
  await tester.tap(find.text(title));
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  await waitForRive(tester);
}

/// Loading a .riv file is real async work (native code), which doesn't run
/// in the test's fake time. Give it real time until the RiveWidget appears.
Future<void> waitForRive(WidgetTester tester) async {
  for (var i = 0; i < 100; i++) {
    if (find.byType(RiveWidget).evaluate().isNotEmpty) break;
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump();
  }
  expect(find.byType(RiveWidget), findsOneWidget);
}

/// Lets the state machine run for [frames] frames.
Future<void> runFrames(WidgetTester tester, [int frames = 30]) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
}
