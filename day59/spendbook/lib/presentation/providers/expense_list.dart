import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_category.dart';
import '../../domain/failures.dart';
import 'dependencies.dart';

part 'expense_list.g.dart';

/// All expenses, newest first, kept up to date by the database.
///
/// It only calls use cases: no Drift, no SQL, no business rules here.
@riverpod
class ExpenseList extends _$ExpenseList {
  @override
  Stream<List<Expense>> build() {
    final watchExpenses = ref.watch(watchExpensesProvider);
    // A Left becomes the provider's error, so the UI gets an AsyncError.
    return watchExpenses().map(
      (result) => result.fold((failure) => throw failure, (list) => list),
    );
  }

  /// The new expense, or why it couldn't be added. The list updates by
  /// itself: the database stream emits again.
  Future<Either<Failure, Expense>> add({
    required String title,
    required int amountCents,
    required ExpenseCategory category,
    required DateTime date,
    String? note,
  }) => ref.read(addExpenseProvider)(
    title: title,
    amountCents: amountCents,
    category: category,
    date: date,
    note: note,
  );

  Future<Either<Failure, Unit>> delete(String id) =>
      ref.read(deleteExpenseProvider)(id);
}
