import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/entities/spending_insight.dart';
import 'package:spendbook/domain/failures.dart';

import '../helpers/fake_budget_repository.dart';
import '../helpers/fake_expense_repository.dart';
import '../helpers/fake_insight_writer.dart';
import '../helpers/test_app.dart';

void main() {
  Future<void> openDashboard(
    WidgetTester tester,
    FakeInsightWriter? ai, {
    FakeExpenseRepository? repository,
  }) async {
    await tester.pumpWidget(
      testApp(
        repository ?? FakeExpenseRepository(sampleExpenses),
        budget: FakeBudgetRepository(30000),
        insightWriter: ai,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();
  }

  testWidgets('the insight appears only after asking for it', (tester) async {
    final ai = FakeInsightWriter(
      right(
        const SpendingInsight(
          headline: 'Food leads your October',
          tip: 'Plan two home-cooked dinners a week.',
        ),
      ),
    );
    await openDashboard(tester, ai);
    expect(ai.summary, isNull); // nothing sent yet

    await tester.tap(find.text('Explain my month'));
    await tester.pumpAndSettle();

    expect(find.text('Food leads your October'), findsOneWidget);
    expect(find.text('Plan two home-cooked dinners a week.'), findsOneWidget);
    expect(find.text('Written by AI. It can make mistakes.'), findsOneWidget);
    expect(ai.budgetCents, 30000);
  });

  testWidgets('a failure is shown in the card', (tester) async {
    await openDashboard(
      tester,
      FakeInsightWriter(left(const AiFailure('Too many requests.'))),
    );

    await tester.tap(find.text('Explain my month'));
    await tester.pumpAndSettle();

    expect(find.text('Too many requests.'), findsOneWidget);
  });

  testWidgets('no Firebase: no insight card', (tester) async {
    await openDashboard(tester, null);

    expect(find.text('Explain my month'), findsNothing);
  });

  testWidgets('a new expense clears the old insight', (tester) async {
    final repository = FakeExpenseRepository(sampleExpenses);
    await openDashboard(
      tester,
      FakeInsightWriter(
        right(const SpendingInsight(headline: 'A calm month', tip: 'Nice.')),
      ),
      repository: repository,
    );
    await tester.tap(find.text('Explain my month'));
    await tester.pumpAndSettle();
    expect(find.text('A calm month'), findsOneWidget);

    await repository.addExpense(
      Expense(
        id: 'new',
        title: 'Laptop',
        amountCents: 99900,
        category: ExpenseCategory.shopping,
        date: DateTime(2026, 10, 28),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('A calm month'), findsNothing);
    expect(find.text('Explain my month'), findsOneWidget);
  });
}
