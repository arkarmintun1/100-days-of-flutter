import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motion_lab/main.dart';

void main() {
  Future<void> open(WidgetTester tester, String demo) async {
    await tester.pumpWidget(const MotionLabApp());
    await tester.tap(find.text(demo));
    await tester.pumpAndSettle();
  }

  Size boxSize(WidgetTester tester) => tester.getSize(
    find.ancestor(
      of: find.text('Tap me'),
      matching: find.byType(AnimatedContainer),
    ),
  );

  testWidgets('the magic box animates through the sizes in between', (
    tester,
  ) async {
    await open(tester, 'Magic box');
    expect(boxSize(tester), const Size(100, 100));

    await tester.tap(find.text('Tap me'));
    await tester.pump(); // the animation starts
    await tester.pump(const Duration(milliseconds: 400)); // halfway

    final halfway = boxSize(tester).width;
    expect(halfway, greaterThan(100));
    expect(halfway, lessThan(250));

    await tester.pumpAndSettle(); // the end
    expect(boxSize(tester), const Size(250, 250));
  });

  testWidgets('the sidebar slides in from the left', (tester) async {
    await open(tester, 'Sidebar');
    double left() => tester.getTopLeft(find.text('Favorites')).dx;

    expect(left(), lessThan(0)); // off screen

    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    expect(left(), greaterThan(0)); // on screen

    // Tapping the dimmed page closes it.
    await tester.tapAt(const Offset(350, 400));
    await tester.pumpAndSettle();
    expect(left(), lessThan(0));
  });

  testWidgets('the counter counts up, then the badge appears', (tester) async {
    await open(tester, 'Counter');

    for (var i = 0; i < 4; i++) {
      await tester.tap(find.text('+2,500 steps'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300)); // mid-count
      if (i == 3) {
        // Between 7,500 and 10,000, not jumping straight to the end.
        expect(find.text('10000 steps'), findsNothing);
        // The badge waits for the count to finish (onEnd).
        expect(find.text('Goal reached!'), findsNothing);
      }
      await tester.pumpAndSettle();
    }

    expect(find.text('10000 steps'), findsOneWidget);
    expect(find.text('Goal reached!'), findsOneWidget);
  });
}
