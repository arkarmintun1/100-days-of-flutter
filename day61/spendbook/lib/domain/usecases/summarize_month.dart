import '../entities/expense.dart';
import '../entities/expense_category.dart';

/// How much was spent in one month.
class MonthlySummary {
  const MonthlySummary({
    required this.totalCents,
    required this.byCategory,
    required this.count,
  });

  final int totalCents;

  /// Only categories with expenses, biggest first.
  final Map<ExpenseCategory, int> byCategory;

  /// How many expenses.
  final int count;
}

/// Pure business logic: no repository, nothing that can fail, so no Either.
class SummarizeMonth {
  const SummarizeMonth();

  MonthlySummary call(
    List<Expense> expenses, {
    required int year,
    required int month,
  }) {
    final inMonth = expenses.where(
      (e) => e.date.year == year && e.date.month == month,
    );

    final totals = <ExpenseCategory, int>{};
    var total = 0;
    var count = 0;
    for (final expense in inMonth) {
      totals.update(
        expense.category,
        (sum) => sum + expense.amountCents,
        ifAbsent: () => expense.amountCents,
      );
      total += expense.amountCents;
      count++;
    }

    final biggestFirst = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return MonthlySummary(
      totalCents: total,
      byCategory: Map.fromEntries(biggestFirst),
      count: count,
    );
  }
}
