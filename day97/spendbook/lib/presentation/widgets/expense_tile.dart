import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/expense.dart';
import '../formatting/money.dart';
import '../l10n.dart';
import 'category_look.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile(this.expense, {super.key, this.onDelete});

  final Expense expense;

  /// A long press, or a screen reader's "Delete" action (Day 97).
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final category = expense.category;
    final l10n = context.l10n;
    // Day 97: above 150% text, the amount goes under the title (beside
    // it, the title gets squeezed), and the details may take more lines.
    final bigText = MediaQuery.textScalerOf(context).scale(10) > 15;
    final amount = Text(
      formatCents(expense.amountCents, l10n.localeName),
      style: Theme.of(context).textTheme.titleMedium,
    );
    final details = Text(
      [
        category.labelIn(l10n),
        DateFormat.MMMd(l10n.localeName).format(expense.date),
        // Paid in another currency (Day 63): show what was paid.
        if (expense.original case final paid?)
          formatMinor(paid.minorUnits, paid.currency, l10n.localeName),
        ?expense.note,
      ].join(' · '),
      maxLines: bigText ? null : 1,
      overflow: bigText ? null : TextOverflow.ellipsis,
    );
    final tile = ListTile(
      onLongPress: onDelete,
      leading: CircleAvatar(
        backgroundColor: category.color.withValues(alpha: 0.15),
        foregroundColor: category.color,
        child: Icon(category.icon),
      ),
      title: Text(expense.title),
      subtitle: bigText
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [amount, details],
            )
          : details,
      trailing: bigText ? null : amount,
    );
    if (onDelete == null) return tile;
    // Day 97: a long press is hard to find with a screen reader. A custom
    // action shows up in TalkBack's actions menu and VoiceOver's rotor.
    return Semantics(
      customSemanticsActions: {
        CustomSemanticsAction(label: l10n.delete): onDelete!,
      },
      child: tile,
    );
  }
}
