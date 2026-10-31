import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/expense.dart';
import '../formatting/money.dart';
import '../l10n.dart';
import 'category_look.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile(this.expense, {super.key, this.onLongPress});

  final Expense expense;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final category = expense.category;
    final l10n = context.l10n;
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
          category.labelIn(l10n),
          DateFormat.MMMd(l10n.localeName).format(expense.date),
          // Paid in another currency (Day 63): show what was paid.
          if (expense.original case final paid?)
            formatMinor(paid.minorUnits, paid.currency, l10n.localeName),
          ?expense.note,
        ].join(' · '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        formatCents(expense.amountCents, l10n.localeName),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
