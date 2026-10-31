import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/expense.dart';
import '../../domain/failures.dart';
import '../l10n.dart';
import '../providers/expense_filter.dart';
import '../providers/expense_list.dart';
import '../widgets/category_look.dart';
import '../widgets/filter_bar.dart';
import '../widgets/expense_tile.dart';
import '../widgets/language_menu.dart';
import 'account_screen.dart';
import 'add_expense_screen.dart';

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(filteredExpensesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spendbook'),
        actions: [
          // Day 96: English or Myanmar.
          const LanguageMenu(),
          // Day 90: who is signed in.
          IconButton(
            tooltip: context.l10n.account,
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const AccountScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const MonthHeader(),
          const CategoryFilterBar(),
          Expanded(
            child: switch (expenses) {
              AsyncData(value: []) => const _EmptyList(),
              AsyncData(value: final expenses) => _ExpenseListView(expenses),
              AsyncError(:final error) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    error is Failure
                        ? error.message
                        : context.l10n.somethingWentWrong,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const AddExpenseScreen()),
        ),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.addExpense),
      ),
    );
  }
}

class _ExpenseListView extends ConsumerWidget {
  const _ExpenseListView(this.expenses);

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      // Room for the FAB below the last expense.
      padding: const EdgeInsets.only(bottom: 88),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return ExpenseTile(
          expense,
          onLongPress: () => _confirmDelete(context, ref, expense),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Expense expense,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteExpenseTitle),
        content: Text(l10n.deleteExpenseBody(expense.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    // The list may be gone by now (e.g. another month was picked).
    if (confirmed != true || !context.mounted) return;

    final result = await ref
        .read(expenseListProvider.notifier)
        .delete(expense.id);
    if (!messenger.mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(switch (result) {
          Left(value: final failure) => failure.message,
          Right() => l10n.deleted(expense.title),
        }),
      ),
    );
  }
}

class _EmptyList extends ConsumerWidget {
  const _EmptyList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(currentFilterProvider);
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(switch (filter.category) {
            null => l10n.noExpensesIn(filter.month),
            final category => l10n.noCategoryExpensesIn(
              category.labelIn(l10n),
              filter.month,
            ),
          }),
        ],
      ),
    );
  }
}
