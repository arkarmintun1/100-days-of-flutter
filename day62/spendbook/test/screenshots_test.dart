// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_budget_repository.dart';
import 'helpers/fake_expense_repository.dart';
import 'helpers/screenshot_helper.dart';
import 'helpers/test_app.dart';

/// Screenshots for the blog posts (written to test/screenshots/).
void main() {
  setUpAll(loadRealFonts);

  testWidgets(
    'day59_list',
    (t) => screenshot(
      t,
      'day59_list',
      testApp(FakeExpenseRepository(sampleExpenses)),
    ),
  );

  testWidgets(
    'day59_add',
    (t) => screenshot(
      t,
      'day59_add',
      testApp(FakeExpenseRepository()),
      before: (t) async {
        await t.tap(find.text('Add expense'));
        await t.pumpAndSettle();
        await t.enterText(find.widgetWithText(TextFormField, 'Amount'), '4.20');
        await t.enterText(
          find.widgetWithText(TextFormField, 'Title'),
          'Bubble tea',
        );
        await t.tap(find.text('Shopping'));
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day60_filter',
    (t) => screenshot(
      t,
      'day60_filter',
      testApp(FakeExpenseRepository(sampleExpenses)),
      before: (t) async {
        await t.tap(find.widgetWithText(ChoiceChip, 'Food'));
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day61_dashboard',
    (t) => screenshot(
      t,
      'day61_dashboard',
      testApp(FakeExpenseRepository(sampleExpenses)),
      before: (t) async {
        await t.tap(find.text('Dashboard'));
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day62_budget',
    (t) => screenshot(
      t,
      'day62_budget',
      testApp(
        FakeExpenseRepository(sampleExpenses),
        budget: FakeBudgetRepository(30000),
      ),
      before: (t) async {
        await t.tap(find.text('Dashboard'));
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day62_daily',
    (t) => screenshot(
      t,
      'day62_daily',
      testApp(
        FakeExpenseRepository(sampleExpenses),
        budget: FakeBudgetRepository(30000),
      ),
      before: (t) async {
        await t.tap(find.text('Dashboard'));
        await t.pumpAndSettle();
        await t.drag(find.byType(ListView).last, const Offset(0, -600));
        await t.pumpAndSettle();
      },
    ),
  );
}
