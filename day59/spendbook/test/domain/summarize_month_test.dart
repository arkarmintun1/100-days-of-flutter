import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/usecases/summarize_month.dart';

Expense expense(int cents, ExpenseCategory category, DateTime date) => Expense(
  id: '$cents-$date',
  title: 'Test',
  amountCents: cents,
  category: category,
  date: date,
);

void main() {
  const summarize = SummarizeMonth();

  final expenses = [
    expense(1250, ExpenseCategory.food, DateTime(2026, 10, 1)),
    expense(4000, ExpenseCategory.bills, DateTime(2026, 10, 5)),
    expense(750, ExpenseCategory.food, DateTime(2026, 10, 31, 23, 59)),
    expense(9999, ExpenseCategory.food, DateTime(2026, 9, 30)), // September
    expense(9999, ExpenseCategory.food, DateTime(2025, 10, 10)), // last year
  ];

  test('totals one month, per category, biggest first', () {
    final october = summarize(expenses, year: 2026, month: 10);

    expect(october.totalCents, 6000);
    expect(october.count, 3);
    expect(october.byCategory, {
      ExpenseCategory.bills: 4000,
      ExpenseCategory.food: 2000,
    });
    expect(october.byCategory.keys.first, ExpenseCategory.bills);
  });

  test('a month without expenses', () {
    final august = summarize(expenses, year: 2026, month: 8);

    expect(august.totalCents, 0);
    expect(august.count, 0);
    expect(august.byCategory, isEmpty);
  });
}
