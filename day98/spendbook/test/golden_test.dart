// Day 88: golden tests. Each screen is drawn to a PNG and compared with the
// approved one in test/goldens/, pixel by pixel.
//
//   fvm flutter test test/golden_test.dart                    # compare
//   fvm flutter test test/golden_test.dart --update-goldens   # approve
//
// The goldens use real fonts, and fonts are drawn a little differently on
// each operating system: make (and check) them on one OS. Elsewhere, leave
// them out with: fvm flutter test -x golden
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_budget_repository.dart';
import 'helpers/fake_expense_repository.dart';
import 'helpers/screenshot_helper.dart';
import 'helpers/test_app.dart';

/// Phone sizes in logical pixels.
const small = Size(320, 568); // iPhone SE (1st generation)
const large = Size(430, 932); // iPhone 15 Pro Max

void main() {
  setUpAll(loadRealFonts);

  /// Draws Spendbook as a phone would show it, then compares it.
  Future<void> golden(
    WidgetTester tester,
    String name, {
    Brightness brightness = Brightness.light,
    double textScale = 1.0,
    Size size = const Size(390, 844),
    bool dashboard = false,
  }) async {
    // What the phone tells the app: its screen, dark mode, font size.
    tester.view.physicalSize = size * 2;
    tester.view.devicePixelRatio = 2;
    tester.platformDispatcher.platformBrightnessTestValue = brightness;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);

    await tester.pumpWidget(
      testApp(
        FakeExpenseRepository(sampleExpenses),
        budget: FakeBudgetRepository(50000),
      ),
    );
    await tester.pumpAndSettle();
    if (dashboard) {
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();
    }

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/$name.png'),
    );
  }

  group('expenses', () {
    testWidgets('light', (t) => golden(t, 'expenses_light'));
    testWidgets(
      'dark',
      (t) => golden(t, 'expenses_dark', brightness: Brightness.dark),
    );
    testWidgets(
      'small phone, text 2x',
      (t) => golden(t, 'expenses_small_text2x', size: small, textScale: 2),
    );
  });

  group('dashboard', () {
    testWidgets('light', (t) => golden(t, 'dashboard_light', dashboard: true));
    testWidgets(
      'dark',
      (t) => golden(
        t,
        'dashboard_dark',
        brightness: Brightness.dark,
        dashboard: true,
      ),
    );
    testWidgets(
      'large phone',
      (t) => golden(t, 'dashboard_large', size: large, dashboard: true),
    );
    testWidgets(
      'small phone, text 2x',
      (t) => golden(
        t,
        'dashboard_small_text2x',
        size: small,
        textScale: 2,
        dashboard: true,
      ),
    );
  });
}
