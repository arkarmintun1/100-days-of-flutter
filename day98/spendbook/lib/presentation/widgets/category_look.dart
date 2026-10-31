import 'package:flutter/material.dart';

import '../../domain/entities/expense_category.dart';
import '../../l10n/app_localizations.dart';

/// How each category looks. UI only, so it lives in presentation, not in
/// the domain's enum.
extension ExpenseCategoryLook on ExpenseCategory {
  /// In English: the assistant's screens aren't translated yet.
  String get label => switch (this) {
    .food => 'Food',
    .transport => 'Transport',
    .shopping => 'Shopping',
    .bills => 'Bills',
    .entertainment => 'Fun',
    .health => 'Health',
    .other => 'Other',
  };

  /// Day 96: in the app's language.
  String labelIn(AppLocalizations l10n) => switch (this) {
    .food => l10n.categoryFood,
    .transport => l10n.categoryTransport,
    .shopping => l10n.categoryShopping,
    .bills => l10n.categoryBills,
    .entertainment => l10n.categoryEntertainment,
    .health => l10n.categoryHealth,
    .other => l10n.categoryOther,
  };

  IconData get icon => switch (this) {
    .food => Icons.restaurant,
    .transport => Icons.directions_bus,
    .shopping => Icons.shopping_bag,
    .bills => Icons.receipt_long,
    .entertainment => Icons.movie,
    .health => Icons.favorite,
    .other => Icons.more_horiz,
  };

  Color get color => switch (this) {
    .food => const Color(0xFFEF6C00),
    .transport => const Color(0xFF1E88E5),
    .shopping => const Color(0xFF8E24AA),
    .bills => const Color(0xFF546E7A),
    .entertainment => const Color(0xFFD81B60),
    .health => const Color(0xFF43A047),
    .other => const Color(0xFF757575),
  };
}
