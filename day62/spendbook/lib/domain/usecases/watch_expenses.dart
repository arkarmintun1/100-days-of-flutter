import 'package:fpdart/fpdart.dart';

import '../entities/expense.dart';
import '../failures.dart';
import '../repositories/expense_repository.dart';

class WatchExpenses {
  const WatchExpenses(this._repository);

  final ExpenseRepository _repository;

  Stream<Either<Failure, List<Expense>>> call() => _repository.watchExpenses();
}
