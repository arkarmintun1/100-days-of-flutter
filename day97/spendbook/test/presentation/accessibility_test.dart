import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_budget_repository.dart';
import '../helpers/fake_expense_repository.dart';
import '../helpers/fake_locale_store.dart';
import '../helpers/screenshot_helper.dart';
import '../helpers/test_app.dart';

/// Day 97: an accessibility check of Spendbook's main screens.
void main() {
  // Real fonts: flutter test's own font draws every character as a square
  // box, much wider than real text (and the same height for Myanmar).
  setUpAll(loadRealFonts);

  Future<void> open(WidgetTester tester, String screen) async {
    switch (screen) {
      case 'add':
        await tester.tap(find.byType(FloatingActionButton));
      case 'dashboard':
        await tester.tap(find.byIcon(Icons.pie_chart_outline));
    }
    await tester.pumpAndSettle();
  }

  group("Flutter's guidelines", () {
    for (final dark in [false, true]) {
      for (final screen in ['expenses', 'add', 'dashboard']) {
        testWidgets('$screen${dark ? ', dark' : ''}', (tester) async {
          final semantics = tester.ensureSemantics();
          if (dark) {
            tester.platformDispatcher.platformBrightnessTestValue =
                Brightness.dark;
            addTearDown(
              tester.platformDispatcher.clearPlatformBrightnessTestValue,
            );
          }
          await tester.pumpWidget(
            testApp(
              FakeExpenseRepository(sampleExpenses),
              budget: FakeBudgetRepository(30000),
            ),
          );
          await tester.pumpAndSettle();
          await open(tester, screen);

          // Android: at least 48x48 to tap. iOS: 44x44.
          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
          // Everything you can tap has a label (or a tooltip).
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          // Text against its background: WCAG's 4.5:1 (3:1 for big text).
          await expectLater(tester, meetsGuideline(textContrastGuideline));
          semantics.dispose();
        });
      }
    }
  });

  group('big text on a small phone', () {
    for (final scale in [2.0, 3.0]) {
      for (final language in ['en', 'my']) {
        for (final screen in ['expenses', 'add', 'dashboard']) {
          testWidgets('$screen, $language, ${scale}x', (tester) async {
            tester.view.physicalSize = const Size(320, 568) * 2;
            tester.view.devicePixelRatio = 2;
            addTearDown(tester.view.reset);
            tester.platformDispatcher.textScaleFactorTestValue = scale;
            addTearDown(
              tester.platformDispatcher.clearTextScaleFactorTestValue,
            );

            await tester.pumpWidget(
              testApp(
                FakeExpenseRepository(sampleExpenses),
                budget: FakeBudgetRepository(30000),
                locale: FakeLocaleStore(language),
              ),
            );
            await tester.pumpAndSettle();
            await open(tester, screen);

            // No overflow, no layout errors.
            expect(tester.takeException(), isNull);
          });
        }
      }
    }
  });

  group('what a screen reader gets', () {
    testWidgets('an expense can be deleted without a long press', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(testApp(FakeExpenseRepository(sampleExpenses)));
      await tester.pumpAndSettle();

      final tile = tester.getSemantics(find.text('Groceries'));
      const delete = CustomSemanticsAction(label: 'Delete');
      expect(tile, isSemantics(customActions: [delete]));

      // What TalkBack or VoiceOver do when the action is picked.
      tile.owner!.performAction(
        tile.id,
        SemanticsAction.customAction,
        CustomSemanticsAction.getIdentifier(delete),
      );
      await tester.pumpAndSettle();
      expect(find.text('Delete expense?'), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('the month header is one live region', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(testApp(FakeExpenseRepository(sampleExpenses)));
      await tester.pumpAndSettle();

      expect(
        // .first: the dashboard has the same header (IndexedStack).
        tester.getSemantics(find.text(r'$185.45').first),
        isSemantics(
          label: 'October 2026\n\$185.45\n5 expenses',
          isLiveRegion: true,
        ),
      );
      semantics.dispose();
    });

    testWidgets('the budget ring and the daily chart have labels', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        testApp(
          FakeExpenseRepository(sampleExpenses),
          budget: FakeBudgetRepository(30000),
        ),
      );
      await tester.pumpAndSettle();
      await open(tester, 'dashboard');

      expect(find.bySemanticsLabel('62% of the budget used'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.bySemanticsLabel(RegExp('^Daily spending chart')),
        300,
        scrollable: find.byType(Scrollable).last,
      );
      expect(
        find.bySemanticsLabel('Daily spending chart. Most on day 20: \$87.35.'),
        findsOneWidget,
      );
      semantics.dispose();
    });
  });
}
