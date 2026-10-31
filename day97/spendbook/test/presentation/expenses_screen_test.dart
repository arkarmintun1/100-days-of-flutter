import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/domain/failures.dart';

import '../helpers/fake_expense_repository.dart';
import '../helpers/test_app.dart';

void main() {
  testWidgets('no expenses yet', (tester) async {
    await tester.pumpWidget(testApp(FakeExpenseRepository()));
    await tester.pumpAndSettle();

    expect(find.text('No expenses in October 2026.'), findsOneWidget);
  });

  testWidgets('shows expenses, newest first, with amounts', (tester) async {
    await tester.pumpWidget(testApp(FakeExpenseRepository(sampleExpenses)));
    await tester.pumpAndSettle();

    expect(find.text('Coffee beans'), findsOneWidget);
    expect(find.text(r'$87.35'), findsOneWidget);
    expect(find.text('Bills · Oct 20 · October'), findsOneWidget);
    final first = tester.getTopLeft(find.text('Coffee beans')).dy;
    final second = tester.getTopLeft(find.text('Groceries')).dy;
    expect(first, lessThan(second));
  });

  testWidgets('a storage failure is shown', (tester) async {
    final repository = FakeExpenseRepository()
      ..failWith = const StorageFailure("Couldn't load your expenses.");
    await tester.pumpWidget(testApp(repository));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't load your expenses."), findsOneWidget);
  });

  group('adding', () {
    Future<void> openForm(
      WidgetTester tester,
      FakeExpenseRepository repo,
    ) async {
      await tester.pumpWidget(testApp(repo));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add expense'));
      await tester.pumpAndSettle();
    }

    Finder field(String label) => find.widgetWithText(TextFormField, label);

    testWidgets('a new expense appears in the list', (tester) async {
      final repository = FakeExpenseRepository();
      await openForm(tester, repository);

      await tester.enterText(field('Amount'), '12.5');
      await tester.enterText(field('Title'), 'Lunch');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Lunch'), findsOneWidget); // back on the list
      // In the list, and as the month's total in the header (Day 60).
      expect(find.text(r'$12.50'), findsNWidgets(2));
      expect(repository.expenses.single.amountCents, 1250);
      expect(repository.expenses.single.date, testNow);
    });

    testWidgets('the form checks the amount', (tester) async {
      final repository = FakeExpenseRepository();
      await openForm(tester, repository);
      await tester.enterText(field('Title'), 'Lunch');

      // Typed or pasted as is: nothing is silently changed.
      for (final amount in ['12.345', '-5', '12,50', 'abc']) {
        await tester.enterText(field('Amount'), amount);
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        expect(
          find.text('Enter an amount like 12.50'),
          findsOneWidget,
          reason: amount,
        );
      }
      expect(repository.expenses, isEmpty);
    });

    testWidgets("the domain's rules are shown", (tester) async {
      final repository = FakeExpenseRepository();
      await openForm(tester, repository);

      await tester.enterText(field('Amount'), '0');
      await tester.enterText(field('Title'), 'Lunch');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('The amount must be more than 0.'), findsOneWidget);

      await tester.enterText(field('Amount'), '5');
      await tester.enterText(field('Title'), '   ');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a title.'), findsOneWidget);
      expect(repository.expenses, isEmpty);
    });
  });

  testWidgets('long press to delete, after confirming', (tester) async {
    final repository = FakeExpenseRepository(sampleExpenses);
    await tester.pumpWidget(testApp(repository));
    await tester.pumpAndSettle();

    // Day 96: the header got taller, so the last expense starts under the
    // button: scroll it up first.
    await tester.drag(find.text('Groceries'), const Offset(0, -200));
    await tester.pumpAndSettle();
    await tester.longPress(find.text('Cinema'));
    await tester.pumpAndSettle();
    expect(find.text('Delete expense?'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Deleted "Cinema".'), findsOneWidget);
    expect(find.text('Cinema'), findsNothing);
    expect(repository.expenses, hasLength(5));
  });
}
