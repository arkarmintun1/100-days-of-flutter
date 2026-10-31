import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/data/local/app_database.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/presentation/providers/dependencies.dart';
import 'package:spendbook/presentation/providers/expense_filter.dart';
import 'package:spendbook/presentation/providers/expense_list.dart';

/// The real wiring of all three layers, with only the database file
/// swapped for an in-memory one: providers → use cases → repository →
/// Drift.
void main() {
  late ProviderContainer container;

  setUp(() {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    container = ProviderContainer.test(
      retry: (_, _) => null,
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => DateTime(2026, 10, 28, 10)),
      ],
    );
    // Keep the providers alive while the test runs.
    container.listen(filteredExpensesProvider, (_, _) {});
    container.listen(monthSummaryProvider, (_, _) {});
  });

  test(
    'an expense added through the UI layer ends up in the summary',
    () async {
      final added = await container
          .read(expenseListProvider.notifier)
          .add(
            title: 'Lunch',
            amountCents: 1250,
            category: ExpenseCategory.food,
            date: DateTime(2026, 10, 28, 12),
          );
      expect(added.isRight(), isTrue);

      // The database stream emits; the derived providers update.
      await container.pump();
      await pumpEventQueue();

      final summary = container.read(monthSummaryProvider).value!;
      expect(summary.totalCents, 1250);
      expect(summary.byCategory, {ExpenseCategory.food: 1250});
      expect(
        container.read(filteredExpensesProvider).value!.single.title,
        'Lunch',
      );
    },
  );

  test("a rule broken in the domain never reaches the database", () async {
    final added = await container
        .read(expenseListProvider.notifier)
        .add(
          title: '',
          amountCents: 1250,
          category: ExpenseCategory.food,
          date: DateTime(2026, 10, 28),
        );
    expect(added.isLeft(), isTrue);

    final db = container.read(appDatabaseProvider);
    expect(await db.select(db.expenses).get(), isEmpty);
  });
}
