import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart' show Surface;
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/repositories/assistant_model.dart';

import '../helpers/fake_assistant_model.dart';
import '../helpers/fake_budget_repository.dart';
import '../helpers/fake_expense_repository.dart';
import '../helpers/test_app.dart';

void main() {
  final monthAnswer = FakeAssistantModel.answer('month', [
    {
      'id': 'root',
      'component': 'Column',
      'children': ['bills', 'tip'],
    },
    {
      'id': 'bills',
      'component': 'SpendingCard',
      'category': 'bills',
      'amount': 87.35,
      'share': 0.47,
    },
    {
      'id': 'tip',
      'component': 'TipCard',
      'text': 'Bills are your biggest category this month.',
      'mood': 'warning',
    },
  ]);

  Future<void> ask(
    WidgetTester tester,
    FakeAssistantModel model,
    String question,
  ) async {
    await tester.pumpWidget(
      testApp(
        FakeExpenseRepository(sampleExpenses),
        budget: FakeBudgetRepository(30000),
        assistantModel: model,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ask'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), question);
    await tester.tap(find.byTooltip('Send'));
    await finishAnswer(tester);
  }

  testWidgets("the model's A2UI answer becomes Spendbook widgets", (
    tester,
  ) async {
    final model = FakeAssistantModel(monthAnswer);
    await ask(tester, model, 'How am I doing?');

    expect(find.text('How am I doing?'), findsOneWidget); // the question
    expect(find.text('Here is your month.'), findsOneWidget); // plain text
    // The SpendingCard and the TipCard, built from our catalog.
    expect(find.text('Bills'), findsOneWidget);
    expect(find.text(r'$87.35'), findsOneWidget);
    expect(
      find.text('Bills are your biggest category this month.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.warning_amber), findsOneWidget);
  });

  testWidgets('text and A2UI in one chunk still become widgets', (
    tester,
  ) async {
    // Gemini may send the end of an answer as one chunk.
    final model = FakeAssistantModel([monthAnswer.join()]);
    await ask(tester, model, 'How am I doing?');

    expect(find.text('Here is your month.'), findsOneWidget);
    expect(find.text(r'$87.35'), findsOneWidget);
    expect(find.textContaining('createSurface'), findsNothing);
  });

  testWidgets('the question goes with this month as data', (tester) async {
    final model = FakeAssistantModel(monthAnswer);
    await ask(tester, model, 'How am I doing?');

    final request = model.requests.single;
    expect(request, startsWith('<spending>\nMonth: October 2026\n'));
    expect(request, contains(r'Budget: $300.00'));
    expect(request, contains(r'Total: $185.45'));
    expect(request, contains(r'bills: $87.35'));
    expect(request, endsWith('</spending>\nHow am I doing?'));
    // The system prompt describes our widgets.
    expect(model.instructions, contains('SpendingCard'));
    expect(model.instructions, contains('TipCard'));
  });

  testWidgets('a failure is shown in the chat', (tester) async {
    final model = FakeAssistantModel(
      [],
      error: const AiFailure('Too many requests. Try again later.'),
    );
    await ask(tester, model, 'Hi');

    expect(find.text('Too many requests. Try again later.'), findsOneWidget);
  });

  testWidgets('no Firebase: no Ask tab', (tester) async {
    await tester.pumpWidget(testApp(FakeExpenseRepository(sampleExpenses)));
    await tester.pumpAndSettle();

    expect(find.text('Ask'), findsNothing);
  });

  testWidgets('an expense the assistant added can be undone', (tester) async {
    final coffee = Expense(
      id: 'c1',
      title: 'Coffee',
      amountCents: 500,
      category: ExpenseCategory.food,
      date: DateTime(2026, 10, 28),
    );
    final repository = FakeExpenseRepository([...sampleExpenses, coffee]);
    final model = FakeAssistantModel(
      ['Added your coffee.'],
      actionsToReport: [ExpenseAdded(coffee)],
    );
    await tester.pumpWidget(testApp(repository, assistantModel: model));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ask'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Log a 5 dollar coffee');
    await tester.tap(find.byTooltip('Send'));
    await finishAnswer(tester);

    expect(find.text('Added: Coffee'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();

    expect(find.text('Removed: Coffee'), findsOneWidget);
    expect(repository.expenses.any((e) => e.id == 'c1'), isFalse);

    // The next message tells the model about the Undo, once.
    await tester.enterText(find.byType(TextField), 'How much this month?');
    await tester.tap(find.byTooltip('Send'));
    await finishAnswer(tester);
    expect(
      model.requests.last,
      startsWith(
        '<app_events>\nThe user undid "Coffee" (id c1): it was deleted.\n'
        '</app_events>\n<spending>\n',
      ),
    );
    await tester.enterText(find.byType(TextField), 'And now?');
    await tester.tap(find.byTooltip('Send'));
    await finishAnswer(tester);
    expect(model.requests.last, startsWith('<spending>\n'));
  });

  testWidgets('a malformed A2UI message is shown as an error', (tester) async {
    final model = FakeAssistantModel([
      // updateComponents without its components list.
      '{"version":"v0.9","updateComponents":{"surfaceId":"x"}}\n',
    ]);
    await ask(tester, model, 'Hi');

    expect(find.text("Couldn't show the answer."), findsOneWidget);
  });

  testWidgets('while an answer is on its way, nothing else can be sent', (
    tester,
  ) async {
    final hold = Completer<void>();
    final model = FakeAssistantModel(monthAnswer, hold: hold.future);
    await tester.pumpWidget(
      testApp(
        FakeExpenseRepository(sampleExpenses),
        budget: FakeBudgetRepository(30000),
        assistantModel: model,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ask'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'How am I doing?');
    await tester.tap(find.byTooltip('Send'));
    await tester.pump(const Duration(milliseconds: 100));

    bool surfaceIgnoresTaps() => tester
        .widget<IgnorePointer>(
          find
              .ancestor(
                of: find.byType(Surface),
                matching: find.byType(IgnorePointer),
              )
              .first,
        )
        .ignoring;
    IconButton send() => tester.widget<IconButton>(
      find.ancestor(
        of: find.byTooltip('Send'),
        matching: find.byType(IconButton),
      ),
    );

    // The surface is shown, but the answer hasn't ended yet.
    expect(find.text(r'$87.35'), findsOneWidget);
    expect(surfaceIgnoresTaps(), isTrue);
    expect(send().onPressed, isNull);

    hold.complete();
    await finishAnswer(tester);
    expect(surfaceIgnoresTaps(), isFalse);
    expect(send().onPressed, isNotNull);
    expect(model.requests, hasLength(1));
  });

  testWidgets('closing the screen mid-answer closes the model', (tester) async {
    final hold = Completer<void>();
    final model = FakeAssistantModel(monthAnswer, hold: hold.future);
    await tester.pumpWidget(
      testApp(
        FakeExpenseRepository(sampleExpenses),
        budget: FakeBudgetRepository(30000),
        assistantModel: model,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ask'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Add a 4.50 coffee');
    await tester.tap(find.byTooltip('Send'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(model.closed, isFalse);

    await tester.pumpWidget(const SizedBox()); // the screen is gone
    expect(model.closed, isTrue);
    hold.complete();
    await finishAnswer(tester);
  });

  testWidgets("an answer cut off mid-JSON doesn't swallow the next one", (
    tester,
  ) async {
    final model = FakeAssistantModel([
      'Here is your month.\n',
      '{"version":"v0.9","createSurface":', // the answer stops here
    ]);
    await ask(tester, model, 'How am I doing?');

    model.chunks
      ..clear()
      ..addAll(monthAnswer);
    await tester.enterText(find.byType(TextField), 'And now?');
    await tester.tap(find.byTooltip('Send'));
    await finishAnswer(tester);

    expect(find.text(r'$87.35'), findsOneWidget);
  });
}
