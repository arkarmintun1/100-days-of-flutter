import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/presentation/widgets/category_pie_chart.dart';

import '../helpers/fake_expense_repository.dart';
import '../helpers/test_app.dart';

void main() {
  Future<void> openDashboard(WidgetTester tester) async {
    await tester.pumpWidget(testApp(FakeExpenseRepository(sampleExpenses)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();
  }

  testWidgets('one slice and one row per category, biggest first', (
    tester,
  ) async {
    await openDashboard(tester);

    final chart = tester.widget<PieChart>(find.byType(PieChart));
    expect(chart.data.sections, hasLength(5));

    // October: Bills 87.35, Food 45.20, Transport 20, Shopping 18.90, Fun 14.
    final rows = tester
        .widgetList<ListTile>(
          find.descendant(
            of: find.byType(CategoryLegend),
            matching: find.byType(ListTile),
          ),
        )
        .map((tile) => (tile.title! as Text).data)
        .toList();
    expect(rows, ['Bills', 'Food', 'Transport', 'Shopping', 'Fun']);
    expect(find.text('47%'), findsWidgets); // 87.35 of 185.45
    expect(find.text(r'$185.45'), findsWidgets); // header and donut
  });

  testWidgets('the month is shared with the list', (tester) async {
    await openDashboard(tester);

    await tester.tap(find.byTooltip('Previous month'));
    await tester.pumpAndSettle();
    final chart = tester.widget<PieChart>(find.byType(PieChart));
    expect(chart.data.sections, hasLength(1)); // September: only Rent

    await tester.tap(find.text('Expenses'));
    await tester.pumpAndSettle();
    expect(find.text('September 2026'), findsOneWidget);
    expect(find.text('Rent'), findsOneWidget);
  });

  testWidgets('an empty month', (tester) async {
    await tester.pumpWidget(testApp(FakeExpenseRepository()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();

    expect(find.text('No expenses this month.'), findsOneWidget);
    expect(find.byType(PieChart), findsNothing);
  });
}
