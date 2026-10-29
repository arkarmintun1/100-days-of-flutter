import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motion_lab/main.dart';
import 'package:rive/rive.dart';

import 'helpers/rive_helper.dart';

void main() {
  useFlutterRenderer();

  testWidgets('tapping the 4th star: Rive sends an event with rating 4', (
    tester,
  ) async {
    await tester.pumpWidget(const MotionLabApp());
    await openRiveDemo(tester, 'Rating');
    expect(find.text('Tap a star'), findsOneWidget);

    // The stars sit in a row across the middle of the square artboard;
    // the 4th one is at about 64% of its width.
    final box = tester.getRect(find.byType(RiveWidget));
    await tester.tapAt(
      Offset(box.left + box.width * 0.64, box.top + box.height * 0.49),
    );
    await runFrames(tester);

    expect(find.text('You gave 4 out of 5'), findsOneWidget);
  });

  testWidgets('the rewards file has the properties Flutter binds to', (
    tester,
  ) async {
    await tester.pumpWidget(const MotionLabApp());
    await openRiveDemo(tester, 'Rewards');
    await runFrames(tester, 5);

    // The controls only appear when both view model properties were found.
    expect(find.text('+100 coins'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
  });

  testWidgets("Rive's Continue button fires a trigger Flutter listens to", (
    tester,
  ) async {
    await tester.pumpWidget(const MotionLabApp());
    await openRiveDemo(tester, 'Rewards');
    await runFrames(tester, 5);

    // The button is drawn by Rive near the bottom of the artboard.
    final box = tester.getRect(find.byType(RiveWidget));
    await tester.tapAt(
      Offset(box.left + box.width * 0.5, box.top + box.height * 0.906),
    );
    await runFrames(tester);

    expect(find.text('Rewards collected!'), findsOneWidget);
  });
}
