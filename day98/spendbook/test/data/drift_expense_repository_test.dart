import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spendbook/data/local/app_database.dart';
import 'package:spendbook/data/local/expense_local_data_source.dart';
import 'package:spendbook/data/repositories/drift_expense_repository.dart';
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/failures.dart';

/// A data source whose database is broken: every call throws.
class BrokenLocalDataSource implements ExpenseLocalDataSource {
  static final _error = StateError('database is locked');

  @override
  Stream<List<ExpenseRow>> watchAll() => Stream.error(_error);

  @override
  Future<void> insert(ExpenseRow row) => Future.error(_error);

  @override
  Future<int> delete(String id) => Future.error(_error);
}

void main() {
  final lunch = Expense(
    id: 'lunch',
    title: 'Lunch',
    amountCents: 1250,
    category: ExpenseCategory.food,
    date: DateTime(2026, 10, 28, 12, 30),
  );

  group('with a database', () {
    late AppDatabase db;
    late DriftExpenseRepository repository;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repository = DriftExpenseRepository(ExpenseLocalDataSource(db));
    });
    tearDown(() => db.close());

    test('adds, watches and deletes entities', () async {
      expect(await repository.addExpense(lunch), right<Failure, Unit>(unit));

      final saved = await repository.watchExpenses().first;
      expect(saved.getOrElse((f) => fail('$f')), [lunch]);

      expect(
        await repository.deleteExpense('lunch'),
        right<Failure, Unit>(unit),
      );
      final afterDelete = await repository.watchExpenses().first;
      expect(afterDelete.getOrElse((f) => fail('$f')), isEmpty);
    });

    test('deleting an unknown id is a NotFoundFailure', () async {
      final result = await repository.deleteExpense('nope');
      expect(result.getLeft().toNullable(), isA<NotFoundFailure>());
    });

    test(
      'a database error becomes a StorageFailure, not an exception',
      () async {
        await repository.addExpense(lunch);

        // The same id again breaks the primary key.
        final result = await repository.addExpense(lunch);
        expect(result.getLeft().toNullable(), isA<StorageFailure>());
      },
    );
  });

  group('with a broken database', () {
    final repository = DriftExpenseRepository(BrokenLocalDataSource());

    test('watching gives a Left instead of an error', () async {
      final first = await repository.watchExpenses().first;
      expect(first.getLeft().toNullable(), isA<StorageFailure>());
    });

    test('adding and deleting give a StorageFailure', () async {
      expect(
        (await repository.addExpense(lunch)).getLeft().toNullable(),
        isA<StorageFailure>(),
      );
      expect(
        (await repository.deleteExpense('lunch')).getLeft().toNullable(),
        isA<StorageFailure>(),
      );
    });
  });
}
