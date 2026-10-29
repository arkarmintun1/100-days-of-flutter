import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/failures.dart';
import '../providers/expense_filter.dart';
import '../widgets/budget_card.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/daily_bar_chart.dart';
import '../widgets/filter_bar.dart';

/// Where the month's money went.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(monthSummaryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const MonthHeader(),
          switch (summary) {
            AsyncData(:final value) when value.count == 0 => Column(
              children: [
                BudgetCard(spentCents: value.totalCents),
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: Text('No expenses this month.')),
                ),
              ],
            ),
            AsyncData(:final value) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BudgetCard(spentCents: value.totalCents),
                const SizedBox(height: 24),
                CategoryPieChart(value),
                const SizedBox(height: 16),
                CategoryLegend(value),
                const _SectionTitle('Daily spending'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
                  child: DailyBarChart(value.dailyCents),
                ),
              ],
            ),
            AsyncError(:final error) => Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                error is Failure ? error.message : 'Something went wrong.',
                textAlign: TextAlign.center,
              ),
            ),
            _ => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
          },
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
    child: Text(title, style: Theme.of(context).textTheme.titleMedium),
  );
}
