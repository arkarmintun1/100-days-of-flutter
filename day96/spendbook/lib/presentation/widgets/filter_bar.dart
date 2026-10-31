import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/expense_category.dart';
import '../formatting/money.dart';
import '../l10n.dart';
import '../providers/expense_filter.dart';
import 'category_look.dart';

/// "‹ October 2026 ›" and how much was spent that month.
class MonthHeader extends ConsumerWidget {
  const MonthHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // select: rebuild for a new month or total, not for a new category.
    final month = ref.watch(currentFilterProvider.select((f) => f.month));
    final total = ref.watch(
      monthSummaryProvider.select((summary) => summary.value?.totalCents),
    );
    final count = ref.watch(
      monthSummaryProvider.select((summary) => summary.value?.count),
    );
    final l10n = context.l10n;
    final filter = ref.read(currentFilterProvider.notifier);
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      child: Row(
        children: [
          IconButton(
            tooltip: l10n.previousMonth,
            onPressed: filter.previousMonth,
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: Column(
              children: [
                // Day 96: the month's name and digits in the app's language.
                Text(
                  DateFormat.yMMMM(l10n.localeName).format(month),
                  style: text.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  total == null ? '…' : formatCents(total, l10n.localeName),
                  style: text.headlineMedium,
                ),
                // Day 96: a plural ("1 expense", "3 expenses").
                if (count != null)
                  Text(l10n.expenseCount(count), style: text.bodySmall),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.nextMonth,
            onPressed: filter.canGoForward ? filter.nextMonth : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

/// "All" plus one chip per category.
class CategoryFilterBar extends ConsumerWidget {
  const CategoryFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(currentFilterProvider.select((f) => f.category));
    final filter = ref.read(currentFilterProvider.notifier);

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          ChoiceChip(
            label: Text(context.l10n.allCategories),
            selected: selected == null,
            onSelected: (_) => filter.showCategory(null),
          ),
          for (final category in ExpenseCategory.values) ...[
            const SizedBox(width: 8),
            ChoiceChip(
              showCheckmark: false,
              avatar: Icon(category.icon, color: category.color),
              label: Text(category.labelIn(context.l10n)),
              selected: selected == category,
              onSelected: (_) => filter.showCategory(category),
            ),
          ],
        ],
      ),
    );
  }
}
