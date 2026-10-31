import 'package:fpdart/fpdart.dart';

import '../failures.dart';

/// The monthly budget: how much the user plans to spend each month.
abstract interface class BudgetRepository {
  /// In cents; null until the user sets one.
  Stream<Either<Failure, int?>> watchMonthlyBudget();

  Future<Either<Failure, Unit>> setMonthlyBudget(int cents);
}
