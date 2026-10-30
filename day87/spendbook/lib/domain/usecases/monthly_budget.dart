import 'package:fpdart/fpdart.dart';

import '../failures.dart';
import '../repositories/budget_repository.dart';

class const WatchMonthlyBudget(final BudgetRepository _repository) {
  Stream<Either<Failure, int?>> call() => _repository.watchMonthlyBudget();
}

class const SetMonthlyBudget(final BudgetRepository _repository) {
  Future<Either<Failure, Unit>> call(int cents) async {
    if (cents <= 0) {
      return left(const ValidationFailure('The budget must be more than 0.'));
    }
    return _repository.setMonthlyBudget(cents);
  }
}

/// How the month is going against the budget. Pure, like SummarizeMonth.
enum BudgetStatus {
  /// Below 80% of the budget.
  onTrack,

  /// 80% or more, but not over.
  nearLimit,

  /// Spent more than the budget.
  over;

  static BudgetStatus of({required int spentCents, required int budgetCents}) =>
      switch (spentCents * 100 ~/ budgetCents) {
        < 80 => onTrack,
        _ when spentCents <= budgetCents => nearLimit,
        _ => over,
      };
}
