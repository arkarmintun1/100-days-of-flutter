import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/failures.dart';
import '../providers/expense_filter.dart';
import '../widgets/category_pie_chart.dart';
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
            AsyncData(:final value) when value.count == 0 => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('No expenses this month.')),
            ),
            AsyncData(:final value) => Column(
              children: [
                CategoryPieChart(value),
                const SizedBox(height: 16),
                CategoryLegend(value),
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
