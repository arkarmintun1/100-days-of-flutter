import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genui/genui.dart';
import 'package:intl/intl.dart';

import '../../domain/failures.dart';
import '../assistant/assistant_session.dart';
import '../formatting/money.dart';
import '../widgets/category_look.dart';
import '../providers/budget.dart';
import '../providers/dependencies.dart';
import '../providers/expense_filter.dart';

/// Day 73: ask about your spending; Gemini answers with UI (GenUI).
class AssistantScreen extends ConsumerStatefulWidget {
  const AssistantScreen({super.key});

  @override
  ConsumerState<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends ConsumerState<AssistantScreen> {
  late final AssistantSession _session;
  final _question = TextEditingController();

  @override
  void initState() {
    super.initState();
    _session = AssistantSession(
      // Read when the first question is sent, not now.
      createModel: (instructions) =>
          ref.read(assistantModelBuilderProvider)(instructions),
      spending: _spending,
    );
  }

  @override
  void dispose() {
    _session.dispose();
    _question.dispose();
    super.dispose();
  }

  /// The selected month's numbers, as plain text for the prompt. Read when asked,
  /// so the answer is about the data as it is now. Only loaded data: a
  /// list or budget still loading must not look like "$0" or "not set".
  String _spending() {
    final month = ref.read(currentFilterProvider).month;
    final (summary, budget) = switch ((
      ref.read(monthSummaryProvider),
      ref.read(monthlyBudgetProvider),
    )) {
      (AsyncData(value: final summary), AsyncData(value: final budget)) => (
        summary,
        budget,
      ),
      _ => throw const ValidationFailure(
        "Your expenses aren't loaded yet. Try again.",
      ),
    };
    final lines = [
      'Month: ${DateFormat.yMMMM('en_US').format(month)}',
      'Budget: ${budget == null ? 'not set' : formatCents(budget)}',
      'Total: ${formatCents(summary.totalCents)}',
      for (final MapEntry(:key, :value) in summary.byCategory.entries)
        '${key.name}: ${formatCents(value)}',
    ];
    return lines.join('\n');
  }

  Future<void> _undo(ActionEntry entry) async {
    final result = await ref.read(deleteExpenseProvider)(entry.expense.id);
    if (!mounted) return;
    result.match(
      (failure) =>
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(failure.message))),
      (_) => _session.markUndone(entry),
    );
  }

  void _ask() {
    _session.ask(_question.text);
    _question.clear();
  }

  @override
  Widget build(BuildContext context) {
    final month = ref.watch(currentFilterProvider).month;
    return Scaffold(
      appBar: AppBar(title: const Text('Ask Spendbook')),
      body: ListenableBuilder(
        listenable: _session,
        builder: (context, _) => Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_session.entries.isEmpty)
                    const Text('Try: "How am I doing this month?"'),
                  for (final entry in _session.entries) _entry(context, entry),
                  if (_session.isWaiting)
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: _question,
                  enabled: !_session.isWaiting,
                  decoration: InputDecoration(
                    hintText: 'Ask about your spending',
                    // The month selected on the Expenses tab (Day 60).
                    helperText: 'About ${DateFormat.yMMMM().format(month)}',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      tooltip: 'Send',
                      onPressed: _session.isWaiting ? null : _ask,
                      icon: const Icon(Icons.send),
                    ),
                  ),
                  onSubmitted: (_) => _ask(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _entry(BuildContext context, AssistantEntry entry) {
    final colors = Theme.of(context).colorScheme;
    return switch (entry) {
      UserEntry(:final text) => Align(
        alignment: Alignment.centerRight,
        child: Card(
          color: colors.primaryContainer,
          child: Padding(padding: const EdgeInsets.all(12), child: Text(text)),
        ),
      ),
      ReplyEntry(:final text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(text.trim()),
      ),
      // GenUI renders the surface from the catalog.
      // No taps on generated buttons while an answer is on its way.
      SurfaceEntry(:final surfaceId) => IgnorePointer(
        ignoring: _session.isWaiting,
        child: Surface(
          key: ValueKey(surfaceId),
          surfaceContext: _session.controller.contextFor(surfaceId),
        ),
      ),
      // Day 74: the model acted; the user stays in control.
      ActionEntry(:final expense, :final undone) => Card(
        child: ListTile(
          leading: Icon(expense.category.icon, color: expense.category.color),
          title: Text(
            undone ? 'Removed: ${expense.title}' : 'Added: ${expense.title}',
          ),
          subtitle: Text(
            '${formatCents(expense.amountCents)} · '
            '${DateFormat.yMMMd().format(expense.date)}',
          ),
          trailing: undone
              ? null
              : TextButton(
                  onPressed: () => _undo(entry),
                  child: const Text('Undo'),
                ),
        ),
      ),
      ErrorEntry(:final message) => Text(
        message,
        style: TextStyle(color: colors.error),
      ),
    };
  }
}
