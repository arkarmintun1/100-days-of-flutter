import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/usecases/delete_expense.dart';
import 'package:spendbook/presentation/providers/dependencies.dart';
import 'package:spendbook/presentation/providers/expense_list.dart';

import '../helpers/fake_expense_repository.dart';

/// Day 87: a mock of a listener callback. What a provider tells its
/// listeners, and in which order, is an interaction: a mock can check it.
class Listener<T> extends Mock {
  void call(T? previous, T next);
}

/// Day 87: a use case replaced by a mock, inside the provider graph.
class MockDeleteExpense extends Mock implements DeleteExpense {}

typedef Expenses = AsyncValue<List<Expense>>;

/// An AsyncData whose list has exactly these titles, in this order.
Matcher dataWithTitles(List<String> titles) => isA<AsyncData<List<Expense>>>()
    .having((data) => [for (final e in data.value) e.title], 'titles', titles);

void main() {
  final lunch = Expense(
    id: 'lunch',
    title: 'Lunch',
    amountCents: 1250,
    category: ExpenseCategory.food,
    date: DateTime(2026, 10, 28, 12),
  );

  setUpAll(() {
    // any() needs an example value for AsyncValue too.
    registerFallbackValue(const AsyncLoading<List<Expense>>());
  });

  ProviderContainer container({DeleteExpense? deleteExpense}) =>
      ProviderContainer.test(
        retry: (_, _) => null,
        overrides: [
          expenseRepositoryProvider.overrideWithValue(
            FakeExpenseRepository([lunch]),
          ),
          clockProvider.overrideWithValue(() => DateTime(2026, 10, 28, 18)),
          if (deleteExpense != null)
            deleteExpenseProvider.overrideWithValue(deleteExpense),
        ],
      );

  test(
    'listeners hear: loading, the list, then the list with the new one',
    () async {
      final c = container();
      final listener = Listener<Expenses>();
      c.listen(expenseListProvider, listener.call, fireImmediately: true);

      await c.read(expenseListProvider.future);
      await c
          .read(expenseListProvider.notifier)
          .add(
            title: 'Bus',
            amountCents: 300,
            category: ExpenseCategory.transport,
            date: DateTime(2026, 10, 28, 8),
          );
      await pumpEventQueue();

      verifyInOrder([
        // Not a plain null: next to matchers, mocktail takes a null argument
        // for a matcher's place. isNull says it in a matcher.
        () => listener(
          any(that: isNull),
          any(that: isA<AsyncLoading<List<Expense>>>()),
        ),
        () => listener(any(), any(that: dataWithTitles(['Lunch']))),
        () => listener(any(), any(that: dataWithTitles(['Lunch', 'Bus']))),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test('delete goes through the DeleteExpense use case', () async {
    final deleteExpense = MockDeleteExpense();
    when(() => deleteExpense(any())).thenAnswer((_) async => right(unit));
    final c = container(deleteExpense: deleteExpense);

    final result = await c.read(expenseListProvider.notifier).delete('lunch');

    expect(result.isRight(), isTrue);
    verify(() => deleteExpense('lunch')).called(1);
  });
}
