import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// fpdart has its own State class: take only what's needed.
import 'package:fpdart/fpdart.dart' show Left, Right;

import '../../domain/entities/spending_insight.dart';
import '../providers/budget.dart';
import '../providers/dependencies.dart';
import '../providers/expense_filter.dart';
import '../providers/expense_list.dart';

/// Day 71: Gemini looks at the month, when the user asks (each request
/// costs tokens, so not on every rebuild).
class InsightCard extends ConsumerStatefulWidget {
  const InsightCard({super.key});

  @override
  ConsumerState<InsightCard> createState() => _InsightCardState();
}

class _InsightCardState extends ConsumerState<InsightCard> {
  SpendingInsight? _insight;
  String? _error;
  var _busy = false;

  /// Goes up when the data changes: an answer about older data (or one
  /// still on its way) is then thrown away.
  var _version = 0;

  void _dataChanged() {
    _version++;
    if (_insight == null && _error == null && !_busy) return;
    setState(() {
      _insight = null;
      _error = null;
      _busy = false;
    });
  }

  Future<void> _explain() async {
    // The budget must be loaded: "not set" (null) and "not loaded yet"
    // would otherwise look the same to Gemini.
    final int? budget;
    switch (ref.read(monthlyBudgetProvider)) {
      case AsyncData(:final value):
        budget = value;
      case _:
        setState(() => _error = "Your budget isn't loaded yet. Try again.");
        return;
    }
    final version = ++_version;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await ref.read(explainMonthProvider)(
        ref.read(expenseListProvider).value ?? const [],
        month: ref.read(currentFilterProvider).month,
        budgetCents: budget,
      );
      if (!mounted || version != _version) return; // outdated
      switch (result) {
        case Left(value: final failure):
          setState(() => _error = failure.message);
        case Right(value: final insight):
          setState(() => _insight = insight);
      }
    } finally {
      if (mounted && version == _version) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // An expense or the budget changed: the insight no longer fits.
    ref.listen(expenseListProvider, (_, _) => _dataChanged());
    ref.listen(monthlyBudgetProvider, (_, _) => _dataChanged());
    final text = Theme.of(context).textTheme;
    final insight = _insight;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    insight?.headline ?? 'What happened this month?',
                    style: text.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (insight != null) ...[
              Text(insight.tip),
              const SizedBox(height: 8),
              // AI can be wrong: say who wrote it.
              Text(
                'Written by AI. It can make mistakes.',
                style: text.bodySmall,
              ),
            ],
            if (_error case final error?)
              Text(
                error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _busy ? null : _explain,
                child: _busy
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(insight == null ? 'Explain my month' : 'Try again'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
