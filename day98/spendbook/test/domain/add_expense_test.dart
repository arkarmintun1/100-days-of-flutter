import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/usecases/add_expense.dart';

import '../helpers/fake_expense_repository.dart';

void main() {
  final now = DateTime(2026, 10, 28, 9, 30);
  late FakeExpenseRepository repository;
  late AddExpense addExpense;

  setUp(() {
    repository = FakeExpenseRepository();
    addExpense = AddExpense(repository, newId: () => 'id-1', now: () => now);
  });

  Future<Either<Failure, Expense>> add({
    String title = 'Lunch',
    int amountCents = 1250,
    DateTime? date,
    String? note,
  }) => addExpense(
    title: title,
    amountCents: amountCents,
    category: ExpenseCategory.food,
    date: date ?? now,
    note: note,
  );

  /// The failure's message, or fails the test if it succeeded.
  String failureOf(Either<Failure, Expense> result) => switch (result) {
    Left(value: ValidationFailure(:final message)) => message,
    _ => fail('Expected a ValidationFailure, got $result'),
  };

  test('saves a valid expense and returns it', () async {
    final result = await add(title: '  Lunch  ', note: ' with Ko Ko ');

    final expense = result.getOrElse((f) => fail('$f'));
    expect(expense.id, 'id-1');
    expect(expense.title, 'Lunch'); // trimmed
    expect(expense.note, 'with Ko Ko');
    expect(repository.expenses, [expense]);
  });

  test('an empty note is saved as no note', () async {
    final expense = (await add(note: '   ')).getOrElse((f) => fail('$f'));
    expect(expense.note, isNull);
  });

  test('the title is required', () async {
    expect(failureOf(await add(title: '   ')), 'Enter a title.');
    expect(repository.expenses, isEmpty); // nothing was saved
  });

  test('the title has a maximum length', () async {
    expect(await add(title: 'a' * 60), isA<Right<Failure, Expense>>());
    expect(
      failureOf(await add(title: 'a' * 61)),
      'Keep the title to 60 characters or fewer.',
    );
  });

  test('the length counts characters, not UTF-16 code units', () async {
    // '👍' is 1 character but 2 UTF-16 code units.
    expect('👍'.length, 2);
    expect(await add(title: '👍' * 60), isA<Right<Failure, Expense>>());
    expect(await add(title: '👍' * 61), isA<Left<Failure, Expense>>());
  });

  test('the amount must be more than 0', () async {
    expect(failureOf(await add(amountCents: 0)), contains('more than 0'));
    expect(failureOf(await add(amountCents: -500)), contains('more than 0'));
  });

  test('later today is fine; tomorrow is in the future', () async {
    expect(
      await add(date: DateTime(2026, 10, 28, 23, 59)),
      isA<Right<Failure, Expense>>(),
    );
    expect(
      failureOf(await add(date: DateTime(2026, 10, 29))),
      "The date can't be in the future.",
    );
  });

  test("the repository's failure is passed on", () async {
    repository.failWith = const StorageFailure('Disk full.');

    final result = await add();
    expect(result, isA<Left<Failure, Expense>>());
    expect(result.getLeft().toNullable(), isA<StorageFailure>());
  });
}
