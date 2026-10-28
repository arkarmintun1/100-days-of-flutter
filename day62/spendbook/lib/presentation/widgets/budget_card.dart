import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// fpdart has its own State class: take only what's needed.
import 'package:fpdart/fpdart.dart' show Left;

import '../../domain/usecases/monthly_budget.dart';
import '../formatting/money.dart';
import '../providers/budget.dart';
import 'budget_ring.dart';

/// "62% of $300.00": the month's spending against the budget.
class BudgetCard extends ConsumerWidget {
  const BudgetCard({super.key, required this.spentCents});

  final int spentCents;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(monthlyBudgetProvider).value;
    final text = Theme.of(context).textTheme;

    if (budget == null) {
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

    final status = BudgetStatus.of(spentCents: spentCents, budgetCents: budget);
    final color = switch (status) {
      .onTrack => Colors.green,
      .nearLimit => Colors.orange,
      .over => Colors.red,
    };
    final left = budget - spentCents;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            BudgetRing(
              progress: spentCents / budget,
              color: color,
              child: Text(
                '${(spentCents * 100 / budget).round()}%',
                style: text.headlineSmall,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Budget ${formatCents(budget)}',
                    style: text.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    left >= 0
                        ? '${formatCents(left)} left'
                        : '${formatCents(-left)} over',
                    style: text.bodyLarge?.copyWith(color: color),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () => _editBudget(context, ref, budget),
                    child: const Text('Change'),
                  ),
                ],
              ),
            ),
          ],
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message)));
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
