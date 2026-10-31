import 'package:fpdart/fpdart.dart';

import '../entities/expense.dart';
import '../entities/spending_insight.dart';
import '../failures.dart';
import '../usecases/summarize_month.dart';

/// Writes a [SpendingInsight] about a month (Day 71).
abstract interface class InsightWriter {
  Future<Either<Failure, SpendingInsight>> write({
    required DateTime month,
    required MonthlySummary summary,
    required List<Expense> biggest,
    int? budgetCents,
  });
}
