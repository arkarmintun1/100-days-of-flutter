import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/usecases/delete_expense.dart';
import 'package:spendbook/domain/usecases/watch_expenses.dart';

import '../helpers/fake_expense_repository.dart';

void main() {
  final lunch = Expense(
    id: 'lunch',
    title: 'Lunch',
    amountCents: 1250,
    category: ExpenseCategory.food,
    date: DateTime(2026, 10, 28),
  );

  test('watching sees a deletion', () async {
    final repository = FakeExpenseRepository([lunch]);
    final watch = WatchExpenses(repository);
    final delete = DeleteExpense(repository);

    final lengths = <int>[];
    final done = watch().take(2).forEach((result) {
      final expenses = result.getOrElse((f) => fail('$f'));
      lengths.add(expenses.length);
      // Delete right away, from the first list.
      if (lengths.length == 1) delete('lunch');
    });

    await done;
    expect(lengths, [1, 0]);
  });

  test('deleting an unknown id is a NotFoundFailure', () async {
    final delete = DeleteExpense(FakeExpenseRepository());

    final result = await delete('nope');
    expect(result.getLeft().toNullable(), isA<NotFoundFailure>());
  });
}
