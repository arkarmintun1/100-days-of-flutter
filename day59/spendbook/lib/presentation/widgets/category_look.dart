import 'package:flutter/material.dart';

import '../../domain/entities/expense_category.dart';

/// How each category looks. UI only, so it lives in presentation, not in
/// the domain's enum.
extension ExpenseCategoryLook on ExpenseCategory {
  String get label => switch (this) {
    .food => 'Food',
    .transport => 'Transport',
    .shopping => 'Shopping',
    .bills => 'Bills',
    .entertainment => 'Fun',
    .health => 'Health',
    .other => 'Other',
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
