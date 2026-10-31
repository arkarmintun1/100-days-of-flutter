import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendbook/domain/entities/expense.dart';
import 'package:spendbook/domain/entities/expense_category.dart';
import 'package:spendbook/domain/repositories/analytics.dart';
import 'package:spendbook/domain/repositories/assistant_model.dart';
import 'package:spendbook/domain/repositories/category_suggester.dart';
import 'package:spendbook/domain/repositories/error_reporter.dart';
import 'package:spendbook/domain/repositories/insight_writer.dart';
import 'package:spendbook/domain/repositories/receipt_reader.dart';
import 'package:spendbook/domain/repositories/receipt_text_reader.dart';
import 'package:spendbook/main.dart';
import 'package:spendbook/presentation/providers/auth.dart';
import 'package:spendbook/presentation/providers/dependencies.dart';
import 'package:spendbook/presentation/providers/monitoring.dart';
import 'package:spendbook/presentation/providers/sync.dart';

import 'fake_assistant_model.dart';
import 'fake_auth_repository.dart';
import 'fake_budget_repository.dart';
import 'fake_exchange_rate_repository.dart';
import 'fake_expense_repository.dart';
import 'fake_sync_repository.dart';

/// "Now" in every widget test.
final testNow = DateTime(2026, 10, 28, 10);

/// The real app, with fake repositories instead of the database.
Widget testApp(
  FakeExpenseRepository repository, {
  FakeBudgetRepository? budget,
  FakeExchangeRateRepository? rates,
  ReceiptTextReader? receiptReader,
  String? receiptPhoto,
  Future<String?> Function()? takePhoto,
  CategorySuggester? categorySuggester,
  InsightWriter? insightWriter,
  ReceiptReader? aiReceiptReader,
  AssistantModel? assistantModel,
  FakeAuthRepository? auth,
  FakeSyncRepository? sync,
  bool showsBanner = false,
  Analytics? analytics,
}) => ProviderScope(
  retry: (_, _) => null,
  overrides: [
    expenseRepositoryProvider.overrideWithValue(repository),
    budgetRepositoryProvider.overrideWithValue(
      budget ?? FakeBudgetRepository(),
    ),
    exchangeRateRepositoryProvider.overrideWithValue(
      rates ?? FakeExchangeRateRepository(),
    ),
    // No camera and no ML Kit in tests (Day 64).
    takeReceiptPhotoProvider.overrideWithValue(
      takePhoto ?? () async => receiptPhoto,
    ),
    if (receiptReader != null)
      receiptTextReaderProvider.overrideWithValue(receiptReader),
    // No Firebase in tests (Day 70): AI on only with a fake suggester.
    aiEnabledProvider.overrideWithValue(
      categorySuggester != null ||
          insightWriter != null ||
          aiReceiptReader != null ||
          assistantModel != null,
    ),
    if (categorySuggester != null)
      categorySuggesterProvider.overrideWithValue(categorySuggester),
    if (insightWriter != null)
      insightWriterProvider.overrideWithValue(insightWriter),
    if (aiReceiptReader != null)
      receiptReaderProvider.overrideWithValue(aiReceiptReader),
    if (assistantModel != null)
      assistantModelBuilderProvider.overrideWithValue((instructions) {
        if (assistantModel case FakeAssistantModel()) {
          assistantModel.instructions = instructions;
        }
        return assistantModel;
      }),
    clockProvider.overrideWithValue(() => testNow),
    // Day 90: sign-in only with a fake Firebase Auth.
    firebaseReadyProvider.overrideWithValue(auth != null),
    if (auth != null) authRepositoryProvider.overrideWithValue(auth),
    // Day 91: no Firestore in widget tests.
    if (auth != null)
      syncRepositoryProvider.overrideWithValue(sync ?? FakeSyncRepository()),
    // Day 95: never Crashlytics or Analytics in tests.
    errorReporterProvider.overrideWithValue(const LogErrorReporter()),
    analyticsProvider.overrideWithValue(analytics ?? const NoAnalytics()),
  ],
  child: SpendbookApp(showsBanner: showsBanner),
);

/// A few expenses to show.
final sampleExpenses = [
  Expense(
    id: '1',
    title: 'Groceries',
    amountCents: 4520,
    category: ExpenseCategory.food,
    date: DateTime(2026, 10, 27),
  ),
  Expense(
    id: '2',
    title: 'Bus card top-up',
    amountCents: 2000,
    category: ExpenseCategory.transport,
    date: DateTime(2026, 10, 26),
  ),
  Expense(
    id: '3',
    title: 'Electricity',
    amountCents: 8735,
    category: ExpenseCategory.bills,
    date: DateTime(2026, 10, 20),
    note: 'October',
  ),
  Expense(
    id: '4',
    title: 'Cinema',
    amountCents: 1400,
    category: ExpenseCategory.entertainment,
    date: DateTime(2026, 10, 18),
  ),
  Expense(
    id: '5',
    title: 'Coffee beans',
    amountCents: 1890,
    category: ExpenseCategory.shopping,
    date: DateTime(2026, 10, 28),
  ),
  Expense(
    id: '6',
    title: 'Rent',
    amountCents: 120000,
    category: ExpenseCategory.bills,
    date: DateTime(2026, 9, 1),
  ),
];
