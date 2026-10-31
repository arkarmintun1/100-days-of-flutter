import 'package:fpdart/fpdart.dart';

import '../entities/expense.dart';
import '../entities/spending_insight.dart';
import '../failures.dart';
import '../repositories/insight_writer.dart';
import 'summarize_month.dart';

/// Summarizes a month and asks for an insight about it (Day 71).
class ExplainMonth(
  final InsightWriter _writer, {
  final SummarizeMonth _summarize = const SummarizeMonth(),
}) {
  /// Only the biggest expenses go to the AI: enough to explain the month,
  /// fewer tokens, and less personal data sent.
  static const maxExpensesSent = 5;

  Future<Either<Failure, SpendingInsight>> call(
    List<Expense> expenses, {
    required DateTime month,
    int? budgetCents,
  }) async {
    final summary = _summarize(expenses, year: month.year, month: month.month);
    if (summary.count == 0) {
      return left(const ValidationFailure('No expenses this month yet.'));
    }
    final biggest =
        expenses
            .where(
              (e) => e.date.year == month.year && e.date.month == month.month,
            )
            .toList()
          ..sort((a, b) => b.amountCents.compareTo(a.amountCents));
    return _writer.write(
      month: DateTime(month.year, month.month),
      summary: summary,
      biggest: biggest.take(maxExpensesSent).toList(),
      budgetCents: budgetCents,
    );
  }
}
