// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
