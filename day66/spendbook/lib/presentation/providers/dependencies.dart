import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../data/local/app_database.dart';
import '../../data/local/budget_local_data_source.dart';
import '../../data/local/expense_local_data_source.dart';
import '../../data/ocr/ml_kit_receipt_text_reader.dart';
import '../../data/remote/frankfurter_api.dart';
import '../../data/repositories/drift_budget_repository.dart';
import '../../data/repositories/drift_expense_repository.dart';
import '../../data/repositories/frankfurter_exchange_rate_repository.dart';
import '../../domain/repositories/budget_repository.dart';
import '../../domain/repositories/exchange_rate_repository.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/repositories/receipt_text_reader.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/convert_currency.dart';
import '../../domain/usecases/delete_expense.dart';
import '../../domain/usecases/monthly_budget.dart';
import '../../domain/usecases/scan_receipt.dart';
import '../../domain/usecases/watch_expenses.dart';
import '../formatting/money.dart';

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

// Day 62: the monthly budget.

@Riverpod(keepAlive: true)
BudgetRepository budgetRepository(Ref ref) => DriftBudgetRepository(
  BudgetLocalDataSource(ref.watch(appDatabaseProvider)),
);

@riverpod
WatchMonthlyBudget watchMonthlyBudget(Ref ref) =>
    WatchMonthlyBudget(ref.watch(budgetRepositoryProvider));

@riverpod
SetMonthlyBudget setMonthlyBudget(Ref ref) =>
    SetMonthlyBudget(ref.watch(budgetRepositoryProvider));

// Day 63: exchange rates, the app's first remote data source.

@Riverpod(keepAlive: true)
ExchangeRateRepository exchangeRateRepository(Ref ref) =>
    FrankfurterExchangeRateRepository(
      FrankfurterApi.create(),
      now: ref.watch(clockProvider),
    );

@riverpod
ConvertCurrency convertCurrency(Ref ref) => ConvertCurrency(
  ref.watch(exchangeRateRepositoryProvider),
  appCurrency: appCurrency,
);

// Day 64: receipt scanning.

/// Takes a photo and returns its path, or null if the user cancelled.
/// Tests override it, as there's no camera there.
@riverpod
Future<String?> Function() takeReceiptPhoto(Ref ref) => () async {
  final photo = await ImagePicker().pickImage(
    source: ImageSource.camera,
    // Enough for text recognition, and much faster than a full photo.
    maxWidth: 2000,
  );
  return photo?.path;
};

@Riverpod(keepAlive: true)
ReceiptTextReader receiptTextReader(Ref ref) => MlKitReceiptTextReader();

@riverpod
ScanReceipt scanReceipt(Ref ref) =>
    ScanReceipt(ref.watch(receiptTextReaderProvider));
