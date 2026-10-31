import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/entities/spending_insight.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/usecases/explain_month.dart';

import '../helpers/fake_insight_writer.dart';

void main() {
  const insight = SpendingInsight(headline: 'A calm month', tip: 'Keep it up.');
  final october = DateTime(2026, 10);

  Expense expense(String id, int cents, DateTime date) => Expense(
    id: id,
    title: 'Expense $id',
    amountCents: cents,
    category: ExpenseCategory.food,
    date: date,
  );

  test('a month without expenses is not sent to the AI', () async {
    final writer = FakeInsightWriter(right(insight));

    final result = await ExplainMonth(writer)([
      expense('1', 500, DateTime(2026, 9, 30)), // September
    ], month: october);

    expect(result.getLeft().toNullable(), isA<ValidationFailure>());
    expect(writer.summary, isNull);
  });

  test('only the 5 biggest expenses of the month are sent', () async {
    final writer = FakeInsightWriter(right(insight));
    final expenses = [
      for (var i = 1; i <= 7; i++)
        expense('$i', i * 100, DateTime(2026, 10, i)),
      expense('sep', 99900, DateTime(2026, 9, 1)), // another month
    ];

    final result = await ExplainMonth(writer)(
      expenses,
      month: october,
      budgetCents: 50000,
    );

    expect(result.getRight().toNullable(), insight);
    expect(writer.biggest!.map((e) => e.id), ['7', '6', '5', '4', '3']);
    expect(writer.summary!.count, 7);
    expect(writer.budgetCents, 50000);
  });
}
