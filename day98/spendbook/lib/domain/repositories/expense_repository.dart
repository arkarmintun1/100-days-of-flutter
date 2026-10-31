import 'package:fpdart/fpdart.dart';

import '../entities/expense.dart';
import '../failures.dart';

/// What the domain needs from storage, without saying how it's stored.
///
/// The data layer implements it (Day 58). The domain only depends on this
/// interface, so it never imports a database package.
abstract interface class ExpenseRepository {
  /// All expenses, newest first. Emits again whenever they change.
  Stream<Either<Failure, List<Expense>>> watchExpenses();

  Future<Either<Failure, Unit>> addExpense(Expense expense);

  /// A [NotFoundFailure] if there's no expense with this [id].
  Future<Either<Failure, Unit>> deleteExpense(String id);
}
