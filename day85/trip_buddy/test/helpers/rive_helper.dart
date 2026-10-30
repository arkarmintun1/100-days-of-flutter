import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

/// The thinking animation, drawn with Flutter's canvas: flutter test has
/// no GPU for Rive's own renderer (Day 69). Needs Rive's native library
/// on this machine, once:
/// `dart run rive_native:setup --verbose --clean --platform macos` (or
/// linux / windows). Again after `flutter clean`: it copies the library
/// into this app's build folder.
FileLoader testThinkingAnimation() {
  final loader = FileLoader.fromAsset(
    'assets/rive/little_machine.riv',
    riveFactory: Factory.flutter,
  );
  addTearDown(loader.dispose);
  return loader;
}

/// Loading a .riv file is real async work (native code), which doesn't run
/// in the test's fake time. Give it real time until the RiveWidget appears
/// (Day 69).
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
