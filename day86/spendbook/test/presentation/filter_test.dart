import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/presentation/providers/dependencies.dart';
import 'package:spendbook/presentation/providers/expense_filter.dart';
import 'package:spendbook/presentation/providers/expense_list.dart';

import '../helpers/fake_expense_repository.dart';
import '../helpers/test_app.dart';

void main() {
  ProviderContainer container() => ProviderContainer.test(
    retry: (_, _) => null,
    overrides: [
      expenseRepositoryProvider.overrideWithValue(
        FakeExpenseRepository(sampleExpenses),
      ),
      clockProvider.overrideWithValue(() => testNow),
    ],
  );

  /// Listens (so nothing is disposed) and waits for the database stream.
  Future<ProviderContainer> ready() async {
    final c = container();
    c.listen(filteredExpensesProvider, (_, _) {});
    c.listen(monthSummaryProvider, (_, _) {});
    await c.read(expenseListProvider.future);
    return c;
  }

  List<String> titles(ProviderContainer c) => [
    for (final e in c.read(filteredExpensesProvider).value!) e.title,
  ];

  test('starts on this month, all categories', () async {
    final c = await ready();

    expect(c.read(currentFilterProvider).month, DateTime(2026, 10));
    expect(titles(c), [
      'Coffee beans',
      'Groceries',
      'Bus card top-up',
      'Electricity',
      'Cinema',
    ]);
    expect(c.read(monthSummaryProvider).value!.totalCents, 18545);
  });

  test('one category', () async {
    final c = await ready();
    c.read(currentFilterProvider.notifier).showCategory(ExpenseCategory.bills);

    expect(titles(c), ['Electricity']);
    // The month's total still counts every category.
    expect(c.read(monthSummaryProvider).value!.totalCents, 18545);
  });

  test('the previous month, and not past this month', () async {
    final c = await ready();
    final filter = c.read(currentFilterProvider.notifier);

    expect(filter.canGoForward, isFalse);
    filter.nextMonth(); // does nothing
    expect(c.read(currentFilterProvider).month, DateTime(2026, 10));

    filter.previousMonth();
    expect(c.read(currentFilterProvider).month, DateTime(2026, 9));
    expect(titles(c), ['Rent']);
    expect(filter.canGoForward, isTrue);
  });

  test('January goes back to December of the year before', () async {
    final c = await ready();
    final filter = c.read(currentFilterProvider.notifier);
    for (var i = 0; i < 10; i++) {
      filter.previousMonth();
    }
    expect(c.read(currentFilterProvider).month, DateTime(2025, 12));
  });

  test('select: a new category does not notify month listeners', () async {
    final c = await ready();
    var monthChanges = 0;
    c.listen(
      currentFilterProvider.select((f) => f.month),
      (_, _) => monthChanges++,
    );

    c.read(currentFilterProvider.notifier).showCategory(ExpenseCategory.food);
    expect(monthChanges, 0);

    c.read(currentFilterProvider.notifier).previousMonth();
    expect(monthChanges, 1);
  });

  testWidgets('switch month and category on screen', (tester) async {
    await tester.pumpWidget(testApp(FakeExpenseRepository(sampleExpenses)));
    await tester.pumpAndSettle();
    expect(find.text('October 2026'), findsOneWidget);
    expect(find.text(r'$185.45'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Food'));
    await tester.pumpAndSettle();
    expect(find.text('Groceries'), findsOneWidget);
    expect(find.text('Cinema'), findsNothing);

    await tester.tap(find.byTooltip('Previous month'));
    await tester.pumpAndSettle();
    expect(find.text('September 2026'), findsOneWidget);
    expect(find.text('No Food expenses in September 2026.'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'All'));
    await tester.pumpAndSettle();
    expect(find.text('Rent'), findsOneWidget);
  });
}
