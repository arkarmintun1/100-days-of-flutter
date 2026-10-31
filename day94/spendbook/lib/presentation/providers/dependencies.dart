import 'dart:developer';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../data/ai/assistant_tools.dart';
import '../../data/ai/gemini_assistant_model.dart';
import '../../data/ai/ai_errors.dart';
import '../../data/ai/gemini_category_suggester.dart';
import '../../data/ai/gemini_insight_writer.dart';
import '../../data/ai/gemini_receipt_reader.dart';
import '../../data/local/app_database.dart';
import '../../data/local/budget_local_data_source.dart';
import '../../data/local/expense_local_data_source.dart';
import '../../data/ocr/ml_kit_receipt_text_reader.dart';
import '../../data/remote/frankfurter_api.dart';
import '../../data/repositories/drift_budget_repository.dart';
import '../../data/repositories/drift_expense_repository.dart';
import '../../data/repositories/frankfurter_exchange_rate_repository.dart';
import '../../domain/entities/receipt_draft.dart';
import '../../domain/failures.dart';
import '../../domain/repositories/assistant_model.dart';
import '../../domain/repositories/budget_repository.dart';
import '../../domain/repositories/category_suggester.dart';
import '../../domain/repositories/insight_writer.dart';
import '../../domain/repositories/receipt_reader.dart';
import '../../domain/repositories/exchange_rate_repository.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/repositories/receipt_text_reader.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/convert_currency.dart';
import '../../domain/usecases/delete_expense.dart';
import '../../domain/usecases/explain_month.dart';
import '../../domain/usecases/monthly_budget.dart';
import '../../domain/usecases/scan_receipt.dart';
import '../../domain/usecases/suggest_category.dart';
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

// Day 70: AI with Firebase AI Logic.

/// Whether Firebase started (see main.dart). Without a Firebase project
/// the app still works, just without the AI features.
@Riverpod(keepAlive: true)
bool aiEnabled(Ref ref) => false;

/// Firebase AI Logic with the Gemini Developer API. Each Gemini class
/// makes its own model: its own instructions and answer format (Day 71).
@Riverpod(keepAlive: true)
FirebaseAI firebaseAi(Ref ref) => FirebaseAI.googleAI();

@Riverpod(keepAlive: true)
CategorySuggester categorySuggester(Ref ref) =>
    GeminiCategorySuggester(ref.watch(firebaseAiProvider));

@riverpod
SuggestCategory suggestCategory(Ref ref) =>
    SuggestCategory(ref.watch(categorySuggesterProvider));

@Riverpod(keepAlive: true)
InsightWriter insightWriter(Ref ref) =>
    GeminiInsightWriter(ref.watch(firebaseAiProvider));

@riverpod
ExplainMonth explainMonth(Ref ref) =>
    ExplainMonth(ref.watch(insightWriterProvider));

// Day 72: Gemini reads receipt photos.

@Riverpod(keepAlive: true)
ReceiptReader receiptReader(Ref ref) =>
    GeminiReceiptReader(ref.watch(firebaseAiProvider));

/// Photo → draft: Gemini when AI is on, else Day 64's ML Kit + parser
/// (on the device, free). Offline, Gemini falls back to ML Kit too:
/// without a connection, or without an App Check token (getting one needs
/// the network as well).
@riverpod
Future<Either<Failure, ReceiptDraft>> Function(String imagePath) receiptScan(
  Ref ref,
) {
  final onDevice = ref.watch(scanReceiptProvider);
  if (!ref.watch(aiEnabledProvider)) return onDevice.call;
  final gemini = ref.watch(receiptReaderProvider);
  return (imagePath) async {
    final result = await gemini.read(imagePath);
    return switch (result) {
      Left(value: NetworkFailure()) => onDevice(imagePath),
      Left(:final value) when identical(value, appCheckFailed) => () {
        // Online, this hides an App Check setup problem from the user:
        // say so in the log.
        log('No App Check token: read the receipt with ML Kit instead.');
        return onDevice(imagePath);
      }(),
      _ => result,
    };
  };
}

// Day 73: the assistant's chat model. A function: each chat (screen) gets
// a model of its own, with its own history and GenUI instructions.
// Day 74: with tools that run the app's use cases.
@riverpod
AssistantModel Function(String instructions) assistantModelBuilder(Ref ref) {
  final ai = ref.watch(firebaseAiProvider);
  // Read the use case now, not inside the function: this provider is
  // auto-disposed after the screen reads it, and a disposed `ref` can't
  // be used any more. The chat keeps the use case itself.
  final watchExpenses = ref.watch(watchExpensesProvider);
  final tools = AssistantTools(
    addExpense: ref.watch(addExpenseProvider),
    // The current list: the first value of the database stream.
    expenses: () => watchExpenses().first,
    now: ref.watch(clockProvider),
  );
  return (instructions) =>
      GeminiAssistantModel(ai, instructions: instructions, tools: tools);
}
