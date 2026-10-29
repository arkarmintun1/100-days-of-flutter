import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/expense.dart';
import '../../domain/failures.dart';
import '../providers/expense_filter.dart';
import '../providers/expense_list.dart';
import '../widgets/category_look.dart';
import '../widgets/filter_bar.dart';
import '../widgets/expense_tile.dart';
import 'add_expense_screen.dart';

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(filteredExpensesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Spendbook')),
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
                    error is Failure ? error.message : 'Something went wrong.',
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
        label: const Text('Add expense'),
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete expense?'),
        content: Text('"${expense.title}" will be deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
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
          Right() => 'Deleted "${expense.title}".',
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
    final month = DateFormat.yMMMM().format(filter.month);
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
            null => 'No expenses in $month.',
            final category => 'No ${category.label} expenses in $month.',
          }),
        ],
      ),
    );
  }
}
