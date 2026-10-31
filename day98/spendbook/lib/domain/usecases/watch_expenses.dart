import 'package:fpdart/fpdart.dart';

import '../entities/expense.dart';
import '../failures.dart';
import '../repositories/expense_repository.dart';

class const WatchExpenses(final ExpenseRepository _repository) {
  Stream<Either<Failure, List<Expense>>> call() => _repository.watchExpenses();
}
