import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/failures.dart';

import '../helpers/fake_category_suggester.dart';
import '../helpers/fake_expense_repository.dart';
import '../helpers/test_app.dart';

void main() {
  Future<void> openForm(WidgetTester tester, FakeCategorySuggester? ai) async {
    await tester.pumpWidget(
      testApp(FakeExpenseRepository(), categorySuggester: ai),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
  }

  ChoiceChip chip(WidgetTester tester, String label) =>
      tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, label));

  testWidgets('Suggest picks the category the AI chose', (tester) async {
    final ai = FakeCategorySuggester(right(ExpenseCategory.transport));
    await openForm(tester, ai);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title'),
      'Grab to the airport',
    );
    await tester.tap(find.text('Suggest'));
    await tester.pumpAndSettle();

    expect(ai.titles, ['Grab to the airport']);
    expect(chip(tester, 'Transport').selected, isTrue);
    expect(chip(tester, 'Food').selected, isFalse);
  });

  testWidgets('a failure is shown, the category stays', (tester) async {
    final ai = FakeCategorySuggester(
      left(const AiFailure("Couldn't suggest a category.")),
    );
    await openForm(tester, ai);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title'),
      'Something',
    );
    await tester.tap(find.text('Suggest'));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't suggest a category."), findsOneWidget);
    expect(chip(tester, 'Food').selected, isTrue);
  });

  testWidgets('Save waits while the AI is thinking', (tester) async {
    final wait = Completer<void>();
    final ai = FakeCategorySuggester(
      right(ExpenseCategory.transport),
      wait: wait,
    );
    await openForm(tester, ai);

    await tester.enterText(find.widgetWithText(TextFormField, 'Title'), 'Bus');
    await tester.tap(find.text('Suggest'));
    await tester.pump();

    FilledButton save() =>
        tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'));
    expect(save().onPressed, isNull);

    wait.complete();
    await tester.pumpAndSettle();
    expect(save().onPressed, isNotNull);
  });

  testWidgets('no Firebase: no Suggest button', (tester) async {
    await openForm(tester, null);

    expect(find.text('Suggest'), findsNothing);
  });
}
