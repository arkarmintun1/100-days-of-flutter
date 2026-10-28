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
  }) = _Expense;
}
