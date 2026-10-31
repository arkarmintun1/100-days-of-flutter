import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/usecases/monthly_budget.dart';

import '../helpers/fake_budget_repository.dart';

void main() {
  test('the budget must be more than 0', () async {
    final repository = FakeBudgetRepository();
    final setBudget = SetMonthlyBudget(repository);

    final result = await setBudget(0);
    expect(result.getLeft().toNullable(), isA<ValidationFailure>());
    expect(repository.cents, isNull);

    expect((await setBudget(30000)).isRight(), isTrue);
    expect(repository.cents, 30000);
  });

  test('the status, at the edges', () {
    BudgetStatus status(int spent) =>
        BudgetStatus.of(spentCents: spent, budgetCents: 10000);

    expect(status(0), BudgetStatus.onTrack);
    expect(status(7999), BudgetStatus.onTrack); // 79.99%
    expect(status(8000), BudgetStatus.nearLimit); // 80%
    expect(status(10000), BudgetStatus.nearLimit); // exactly the budget
    expect(status(10001), BudgetStatus.over);
  });
}
