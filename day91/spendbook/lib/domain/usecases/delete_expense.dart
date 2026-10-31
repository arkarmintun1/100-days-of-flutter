import 'package:fpdart/fpdart.dart';

import '../failures.dart';
import '../repositories/expense_repository.dart';

class const DeleteExpense(final ExpenseRepository _repository) {
  Future<Either<Failure, Unit>> call(String id) =>
      _repository.deleteExpense(id);
}
