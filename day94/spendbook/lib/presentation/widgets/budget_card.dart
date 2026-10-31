import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// fpdart has its own State class: take only what's needed.
import 'package:fpdart/fpdart.dart' show Left;

import '../../domain/failures.dart';
import '../../domain/usecases/monthly_budget.dart';
import '../formatting/money.dart';
import '../providers/budget.dart';
import 'budget_ring.dart';

/// "62% of $300.00": the month's spending against the budget.
class BudgetCard extends ConsumerWidget {
  const BudgetCard({super.key, required this.spentCents});

  final int spentCents;

  static const _ringSize = 140.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final int budget;
    switch (ref.watch(monthlyBudgetProvider)) {
      case AsyncData(value: final cents?):
        budget = cents;
      case AsyncData(value: null):
        return _noBudget(context, ref);
      case AsyncError(:final error):
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: ListTile(
            leading: const Icon(Icons.error_outline),
            title: Text(
              error is Failure ? error.message : "Couldn't load your budget.",
            ),
          ),
        );
      case _:
        return const SizedBox.shrink(); // loading: only a moment
    }

    final status = BudgetStatus.of(spentCents: spentCents, budgetCents: budget);
    final color = switch (status) {
      .onTrack => Colors.green,
      .nearLimit => Colors.orange,
      .over => Colors.red,
    };
    final left = budget - spentCents;

    final ring = BudgetRing(
      size: _ringSize,
      progress: spentCents / budget,
      color: color,
      child: Text(
        '${(spentCents * 100 / budget).round()}%',
        style: text.headlineSmall,
      ),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Day 88: the 2x-text golden on a small phone showed "Budget
            // $500.00" broken in the middle of words. When the text has no
            // room next to the ring, it goes under it.
            final textRoom = MediaQuery.textScalerOf(context).scale(140);
            final sideBySide =
                constraints.maxWidth >= _ringSize + 16 + textRoom;
            final align = sideBySide ? TextAlign.start : TextAlign.center;
            final details = Column(
              crossAxisAlignment: sideBySide
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                Text(
                  'Budget ${formatCents(budget)}',
                  style: text.titleMedium,
                  textAlign: align,
                ),
                const SizedBox(height: 4),
                Text(
                  left >= 0
                      ? '${formatCents(left)} left'
                      : '${formatCents(-left)} over',
                  style: text.bodyLarge?.copyWith(color: color),
                  textAlign: align,
                ),
                TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () => _editBudget(context, ref, budget),
                  child: const Text('Change'),
                ),
              ],
            );
            return sideBySide
                ? Row(
                    children: [
                      ring,
                      const SizedBox(width: 16),
                      Expanded(child: details),
                    ],
                  )
                : SizedBox(
                    // The card keeps its full width.
                    width: constraints.maxWidth,
                    child: Column(
                      children: [ring, const SizedBox(height: 16), details],
                    ),
                  );
          },
        ),
      ),
    );
  }

  /// Not set yet: offer to set one.
  Widget _noBudget(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        leading: const Icon(Icons.savings_outlined),
        title: const Text('No monthly budget yet'),
        trailing: TextButton(
          onPressed: () => _editBudget(context, ref, null),
          child: const Text('Set budget'),
        ),
      ),
    );
  }

  Future<void> _editBudget(
    BuildContext context,
    WidgetRef ref,
    int? current,
  ) async {
    final cents = await showDialog<int>(
      context: context,
      builder: (context) => _BudgetDialog(current),
    );
    if (cents == null || !context.mounted) return;

    final result = await ref.read(monthlyBudgetProvider.notifier).set(cents);
    if (result case Left(value: final failure) when context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(failure.message)));
    }
  }
}

class _BudgetDialog extends StatefulWidget {
  const _BudgetDialog(this.current);

  final int? current;

  @override
  State<_BudgetDialog> createState() => _BudgetDialogState();
}

class _BudgetDialogState extends State<_BudgetDialog> {
  late final _amount = TextEditingController(
    text: switch (widget.current) {
      final cents? => (cents / 100).toStringAsFixed(2),
      null => '',
    },
  );
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  void _save() {
    final cents = parseCents(_amount.text);
    if (cents == null) {
      setState(() => _error = 'Enter an amount like 300');
      return;
    }
    Navigator.pop(context, cents);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Monthly budget'),
      content: TextField(
        controller: _amount,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(prefixText: r'$ ', errorText: _error),
        onSubmitted: (_) => _save(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
