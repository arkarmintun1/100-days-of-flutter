import 'package:fpdart/fpdart.dart';
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/entities/spending_insight.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/repositories/insight_writer.dart';
import 'package:spendbook/domain/usecases/summarize_month.dart';

/// Answers with [result] and remembers what it was given.
class FakeInsightWriter implements InsightWriter {
  FakeInsightWriter(this.result);

  final Either<Failure, SpendingInsight> result;
  List<Expense>? biggest;
  MonthlySummary? summary;
  int? budgetCents;

  @override
  Future<Either<Failure, SpendingInsight>> write({
    required DateTime month,
    required MonthlySummary summary,
    required List<Expense> biggest,
    int? budgetCents,
  }) async {
    this.summary = summary;
    this.biggest = biggest;
    this.budgetCents = budgetCents;
    return result;
  }
}
