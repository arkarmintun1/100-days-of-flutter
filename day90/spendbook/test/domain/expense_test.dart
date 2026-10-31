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
      AiFailure() => 'AI problem: ${failure.message}',
      AuthFailure() => 'Sign-in problem: ${failure.message}',
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
  // Day 86: what the refactor must not change. Written before moving the
  // entities to primary constructors, and run again after.
  group('pinned down before the refactor', () {
    const sgd = ForeignAmount(
      currency: 'SGD',
      minorUnits: 1600,
      decimalDigits: 2,
    );

    test('toString lists every value (for logs and test failures)', () {
      expect(
        lunch.toString(),
        'Expense(id: 1, title: Lunch, amountCents: 1250, '
        'category: ExpenseCategory.food, date: 2026-10-28 00:00:00.000, '
        'note: null, original: null)',
      );
    });

    test('a ForeignAmount is a value: same values, equal', () {
      const same = ForeignAmount(
        currency: 'SGD',
        minorUnits: 1600,
        decimalDigits: 2,
      );
      expect(sgd, same);
      expect(sgd.hashCode, same.hashCode);
      // A const constructor: identical const values are one object.
      expect(identical(sgd, same), isTrue);
    });

    test('copyWith reaches into the nested ForeignAmount', () {
      final paidInSgd = lunch.copyWith(original: sgd);
      final more = paidInSgd.copyWith.original!(minorUnits: 2000);
      expect(more.original!.minorUnits, 2000);
      expect(more.original!.currency, 'SGD');
      expect(paidInSgd.original!.minorUnits, 1600);
    });

    test('copyWith can set a nullable field back to null', () {
      final noted = lunch.copyWith(note: 'With Ko Ko');
      expect(noted.copyWith(note: null).note, isNull);
    });
  });
}
