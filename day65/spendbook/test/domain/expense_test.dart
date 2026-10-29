import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/failures.dart';

void main() {
  final lunch = Expense(
    id: '1',
    title: 'Lunch',
    amountCents: 1250,
    category: ExpenseCategory.food,
    date: DateTime(2026, 10, 28),
  );

  test('two expenses with the same values are equal', () {
    final same = Expense(
      id: '1',
      title: 'Lunch',
      amountCents: 1250,
      category: ExpenseCategory.food,
      date: DateTime(2026, 10, 28),
    );
    expect(lunch, same);
    expect(lunch.hashCode, same.hashCode);
  });

  test('copyWith changes only what you pass', () {
    final bigger = lunch.copyWith(amountCents: 1500);
    expect(bigger.amountCents, 1500);
    expect(bigger.title, 'Lunch');
    expect(lunch.amountCents, 1250); // the original is unchanged
  });

  test('cents add up exactly; doubles do not', () {
    expect(0.1 + 0.2 == 0.3, isFalse);
    expect(10 + 20 == 30, isTrue); // the same amounts in cents
  });

  test('every failure has a message', () {
    String describe(Failure failure) => switch (failure) {
      ValidationFailure() => 'Check your input: ${failure.message}',
      NotFoundFailure() => 'Not found: ${failure.message}',
      StorageFailure() => 'Storage problem: ${failure.message}',
      NetworkFailure() => 'Network problem: ${failure.message}',
    };

    expect(
      describe(const ValidationFailure('Enter a title.')),
      'Check your input: Enter a title.',
    );
  });

  test('a failure prints its type and message (for logs)', () {
    expect(
      const StorageFailure('Disk full.').toString(),
      'StorageFailure: Disk full.',
    );
  });
}
