import '../entities/expense.dart';
import '../entities/expense_category.dart';

/// How much was spent in one month.
class MonthlySummary {
  const MonthlySummary({
    required this.totalCents,
    required this.byCategory,
    required this.dailyCents,
    required this.count,
  });

  final int totalCents;

  /// Only categories with expenses, biggest first.
  final Map<ExpenseCategory, int> byCategory;

  /// One total per day of the month: [0] is the 1st (Day 62).
  final List<int> dailyCents;

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

    // Day 0 of the next month is the last day of this one.
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final daily = List.filled(daysInMonth, 0);
    final totals = <ExpenseCategory, int>{};
    var total = 0;
    var count = 0;
    for (final expense in inMonth) {
      totals.update(
        expense.category,
        (sum) => sum + expense.amountCents,
        ifAbsent: () => expense.amountCents,
      );
      daily[expense.date.day - 1] += expense.amountCents;
      total += expense.amountCents;
      count++;
    }

    final biggestFirst = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return MonthlySummary(
      totalCents: total,
      byCategory: Map.fromEntries(biggestFirst),
      dailyCents: daily,
      count: count,
    );
  }
}
