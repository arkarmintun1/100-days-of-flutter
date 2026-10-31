import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/presentation/widgets/budget_ring.dart';

import '../helpers/fake_budget_repository.dart';
import '../helpers/fake_expense_repository.dart';
import '../helpers/test_app.dart';

void main() {
  Future<void> openDashboard(
    WidgetTester tester,
    FakeBudgetRepository budget,
  ) async {
    await tester.pumpWidget(
      testApp(FakeExpenseRepository(sampleExpenses), budget: budget),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();
  }

  testWidgets('set a budget, then see how much is left', (tester) async {
    final budget = FakeBudgetRepository();
    await openDashboard(tester, budget);
    expect(find.text('No monthly budget yet'), findsOneWidget);

    await tester.tap(find.text('Set budget'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '300');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(budget.cents, 30000);
    expect(find.text(r'Budget $300.00'), findsOneWidget);
    expect(find.text('62%'), findsOneWidget); // 185.45 of 300
    expect(find.text(r'$114.55 left'), findsOneWidget);
  });

  testWidgets('over the budget', (tester) async {
    await openDashboard(tester, FakeBudgetRepository(15000));

    expect(find.text('124%'), findsOneWidget);
    expect(find.text(r'$35.45 over'), findsOneWidget);
    final ring = tester.widget<BudgetRing>(find.byType(BudgetRing));
    expect(ring.color, Colors.red);
  });

  testWidgets('the dialog checks the amount', (tester) async {
    final budget = FakeBudgetRepository();
    await openDashboard(tester, budget);

    await tester.tap(find.text('Set budget'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'lots');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Enter an amount like 300'), findsOneWidget);
    expect(budget.cents, isNull);
  });

  test('the painter repaints only when something changed', () {
    BudgetRingPainter painter(double progress) => BudgetRingPainter(
      progress: progress,
      color: Colors.green,
      trackColor: Colors.grey,
    );

    expect(painter(0.5).shouldRepaint(painter(0.5)), isFalse);
    expect(painter(0.5).shouldRepaint(painter(0.6)), isTrue);
  });
}
