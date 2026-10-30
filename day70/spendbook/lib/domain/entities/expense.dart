import 'package:freezed_annotation/freezed_annotation.dart';

import 'expense_category.dart';

part 'expense.freezed.dart';

/// One expense: the core business object of the app.
///
/// An entity knows nothing about databases, JSON or Flutter: no fromJson,
/// no toJson, no widgets. Those belong to the outer layers.
@freezed
abstract class Expense with _$Expense {
  const factory Expense({
    required String id,
    required String title,

    /// In cents: $12.50 is 1250. Integers add up exactly; doubles
    /// don't (0.1 + 0.2 is 0.30000000000000004).
    required int amountCents,
    required ExpenseCategory category,
    required DateTime date,
    String? note,

    /// What was really paid, when it wasn't in the app's currency
    /// (Day 63). amountCents is then the converted amount.
    ForeignAmount? original,
  }) = _Expense;
}

/// An amount in another currency, e.g. SGD 16.00.
@freezed
abstract class ForeignAmount with _$ForeignAmount {
  const factory ForeignAmount({
    /// ISO 4217 code, e.g. 'SGD'.
    required String currency,

    /// In the currency's smallest unit: SGD 16.00 is 1600, JPY 1500 is 1500.
    required int minorUnits,

    /// How many decimals the currency has: 2 for SGD, 0 for JPY.
    required int decimalDigits,
  }) = _ForeignAmount;
}
