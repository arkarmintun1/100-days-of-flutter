// For select() (riverpod_annotation doesn't export it).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_category.dart';
import '../../domain/usecases/summarize_month.dart';
import 'dependencies.dart';
import 'expense_list.dart';

part 'expense_filter.freezed.dart';
part 'expense_filter.g.dart';

/// What the list shows: one month, and maybe one category.
@freezed
abstract class ExpenseFilter with _$ExpenseFilter {
  const factory ExpenseFilter({
    /// The first day of the month, e.g. 2026-10-01.
    required DateTime month,

    /// Null: all categories.
    ExpenseCategory? category,
  }) = _ExpenseFilter;
}

@riverpod
class CurrentFilter extends _$CurrentFilter {
  @override
  ExpenseFilter build() {
    final now = ref.watch(clockProvider)();
    return ExpenseFilter(month: DateTime(now.year, now.month));
  }

  /// DateTime(2026, 0) is December 2025: Dart rolls the month over.
  void previousMonth() => state = state.copyWith(
    month: DateTime(state.month.year, state.month.month - 1),
  );

  void nextMonth() {
    if (!canGoForward) return;
    state = state.copyWith(
      month: DateTime(state.month.year, state.month.month + 1),
    );
  }

  /// Not past this month: there are no future expenses.
  bool get canGoForward {
    final now = ref.read(clockProvider)();
    return state.month.isBefore(DateTime(now.year, now.month));
  }

  void showCategory(ExpenseCategory? category) =>
      state = state.copyWith(category: category);
}

/// The expenses that match the filter, newest first.
@riverpod
AsyncValue<List<Expense>> filteredExpenses(Ref ref) {
  final filter = ref.watch(currentFilterProvider);
  return ref
      .watch(expenseListProvider)
      .whenData(
        (expenses) => [
          for (final expense in expenses)
            if (expense.date.year == filter.month.year &&
                expense.date.month == filter.month.month &&
                (filter.category == null ||
                    expense.category == filter.category))
              expense,
        ],
      );
}

@riverpod
SummarizeMonth summarizeMonth(Ref ref) => const SummarizeMonth();

/// The whole month's totals (all categories), for the header and charts.
@riverpod
AsyncValue<MonthlySummary> monthSummary(Ref ref) {
  // Only the month: picking a category doesn't change the month's total.
  final month = ref.watch(currentFilterProvider.select((f) => f.month));
  final summarize = ref.watch(summarizeMonthProvider);
  return ref
      .watch(expenseListProvider)
      .whenData(
        (expenses) => summarize(expenses, year: month.year, month: month.month),
      );
}
