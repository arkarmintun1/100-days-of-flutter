import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../data/local/app_database.dart';
import '../../data/local/expense_local_data_source.dart';
import '../../data/repositories/drift_expense_repository.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/delete_expense.dart';
import '../../domain/usecases/watch_expenses.dart';

part 'dependencies.g.dart';

// The composition root: the only place that knows which implementation
// goes behind each interface. Tests override these providers.

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase.defaults();
  ref.onDispose(db.close);
  return db;
}

/// The domain's interface, implemented by the data layer.
@Riverpod(keepAlive: true)
ExpenseRepository expenseRepository(Ref ref) => DriftExpenseRepository(
  ExpenseLocalDataSource(ref.watch(appDatabaseProvider)),
);

/// The current time. Tests override it to get a fixed "now".
@Riverpod(keepAlive: true)
DateTime Function() clock(Ref ref) => DateTime.now;

@riverpod
AddExpense addExpense(Ref ref) => AddExpense(
  ref.watch(expenseRepositoryProvider),
  newId: const Uuid().v4,
  now: ref.watch(clockProvider),
);

@riverpod
DeleteExpense deleteExpense(Ref ref) =>
    DeleteExpense(ref.watch(expenseRepositoryProvider));

@riverpod
WatchExpenses watchExpenses(Ref ref) =>
    WatchExpenses(ref.watch(expenseRepositoryProvider));
