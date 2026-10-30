import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/expense.dart';
import '../formatting/money.dart';
import 'category_look.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile(this.expense, {super.key, this.onLongPress});

  final Expense expense;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final category = expense.category;
    return ListTile(
      onLongPress: onLongPress,
      leading: CircleAvatar(
        backgroundColor: category.color.withValues(alpha: 0.15),
        foregroundColor: category.color,
        child: Icon(category.icon),
      ),
      title: Text(expense.title),
      subtitle: Text(
        [
          category.label,
          DateFormat.MMMd().format(expense.date),
          // Paid in another currency (Day 63): show what was paid.
          if (expense.original case final paid?)
            formatMinor(paid.minorUnits, paid.currency),
          ?expense.note,
        ].join(' · '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        formatCents(expense.amountCents),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
