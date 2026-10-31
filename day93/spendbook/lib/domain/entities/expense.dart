import 'package:freezed_annotation/freezed_annotation.dart';

import 'expense_category.dart';

part 'expense.freezed.dart';

/// One expense: the core business object of the app.
///
/// An entity knows nothing about databases, JSON or Flutter: no fromJson,
/// no toJson, no widgets. Those belong to the outer layers.
///
/// Day 86: a Dart 3.13 primary constructor. Its `final` parameters are
/// the fields; Freezed adds ==, hashCode, toString and copyWith.
@freezed
class const Expense({
  required final String id,
  required final String title,

  /// In cents: $12.50 is 1250. Integers add up exactly; doubles
  /// don't (0.1 + 0.2 is 0.30000000000000004).
  required final int amountCents,
  required final ExpenseCategory category,
  required final DateTime date,
  final String? note,

  /// What was really paid, when it wasn't in the app's currency
  /// (Day 63). amountCents is then the converted amount.
  final ForeignAmount? original,
}) with _$Expense;

/// An amount in another currency, e.g. SGD 16.00.
@freezed
class const ForeignAmount({
  /// ISO 4217 code, e.g. 'SGD'.
  required final String currency,

  /// In the currency's smallest unit: SGD 16.00 is 1600, JPY 1500 is 1500.
  required final int minorUnits,

  /// How many decimals the currency has: 2 for SGD, 0 for JPY.
  required final int decimalDigits,
}) with _$ForeignAmount;
