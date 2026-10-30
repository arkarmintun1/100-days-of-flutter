import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/data/local/app_database.dart';
import 'package:spendbook/data/local/budget_local_data_source.dart';
import 'package:spendbook/data/repositories/drift_budget_repository.dart';

void main() {
  late AppDatabase db;
  late DriftBudgetRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = DriftBudgetRepository(BudgetLocalDataSource(db));
  });
  tearDown(() => db.close());

  Future<int?> current() async => (await repository.watchMonthlyBudget().first)
      .getOrElse((f) => fail('$f'));

  test('no budget at first, then saved, then updated', () async {
    expect(await current(), isNull);

    await repository.setMonthlyBudget(30000);
    expect(await current(), 30000);

    await repository.setMonthlyBudget(45000); // the same row is updated
    expect(await current(), 45000);
    expect(await db.select(db.budgets).get(), hasLength(1));
  });
}
