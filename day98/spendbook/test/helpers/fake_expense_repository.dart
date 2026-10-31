import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/repositories/expense_repository.dart';

/// Keeps expenses in a list. Set [failWith] to make every call fail.
class FakeExpenseRepository implements ExpenseRepository {
  FakeExpenseRepository([List<Expense> expenses = const []])
    : expenses = [...expenses];

  final List<Expense> expenses;
  Failure? failWith;

  final _changes = StreamController<void>.broadcast();

  @override
  Stream<Either<Failure, List<Expense>>> watchExpenses() {
    final controller = StreamController<Either<Failure, List<Expense>>>();
    StreamSubscription<void>? changes;
    controller
      ..onListen = () {
        // Listen for changes first, so none is missed after the first list.
        changes = _changes.stream.listen((_) => controller.add(_current()));
        controller.add(_current());
      }
      ..onCancel = () => changes?.cancel();
    return controller.stream;
  }

  Either<Failure, List<Expense>> _current() => switch (failWith) {
    final failure? => left(failure),
    null => right([...expenses]..sort((a, b) => b.date.compareTo(a.date))),
  };

  @override
  Future<Either<Failure, Unit>> addExpense(Expense expense) async {
    if (failWith case final failure?) return left(failure);
    expenses.add(expense);
    _changes.add(null);
    return right(unit);
  }

  @override
  Future<Either<Failure, Unit>> deleteExpense(String id) async {
    if (failWith case final failure?) return left(failure);
    final before = expenses.length;
    expenses.removeWhere((e) => e.id == id);
    if (expenses.length == before) {
      return left(const NotFoundFailure('This expense no longer exists.'));
    }
    _changes.add(null);
    return right(unit);
  }
}
