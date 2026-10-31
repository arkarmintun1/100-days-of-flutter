import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/repositories/expense_repository.dart';
import 'package:spendbook/domain/usecases/add_expense.dart';

/// Day 87: a mock. No behavior of its own: each test says what it returns
/// (when/thenAnswer) and checks how it was called (verify).
class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  final now = DateTime(2026, 10, 28, 9, 30);
  late MockExpenseRepository repository;
  late AddExpense addExpense;

  setUpAll(() {
    // any() and captureAny() need an example value for our own types.
    registerFallbackValue(
      Expense(
        id: 'fallback',
        title: 'fallback',
        amountCents: 1,
        category: ExpenseCategory.other,
        date: DateTime(2026),
      ),
    );
  });

  setUp(() {
    repository = MockExpenseRepository();
    addExpense = AddExpense(repository, newId: () => 'id-1', now: () => now);
  });

  Future<Either<Failure, Expense>> add({String title = 'Lunch'}) => addExpense(
    title: title,
    amountCents: 1250,
    category: ExpenseCategory.food,
    date: now,
  );

  test('saves the cleaned-up expense, exactly once', () async {
    when(() => repository.addExpense(any()))
        .thenAnswer((_) async => right(unit));

    await add(title: '  Lunch  ');

    final saved =
        verify(() => repository.addExpense(captureAny())).captured.single
            as Expense;
    expect(saved.id, 'id-1');
    expect(saved.title, 'Lunch');
  });

  test('an invalid expense never reaches the repository', () async {
    final result = await add(title: '   ');

    expect(result.isLeft(), isTrue);
    verifyNever(() => repository.addExpense(any()));
  });

  test("the repository's failure comes back unchanged", () async {
    const diskFull = StorageFailure('Disk full.');
    when(() => repository.addExpense(any()))
        .thenAnswer((_) async => left(diskFull));

    final result = await add();

    expect(result.getLeft().toNullable(), same(diskFull));
  });
}
