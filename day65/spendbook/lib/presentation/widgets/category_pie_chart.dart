import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../domain/usecases/summarize_month.dart';
import '../formatting/money.dart';
import 'category_look.dart';

/// The month's spending per category, as a donut chart. Touch a slice to
/// make it stand out.
class CategoryPieChart extends StatefulWidget {
  const CategoryPieChart(this.summary, {super.key});

  final MonthlySummary summary;

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  /// The touched slice, or -1.
  var _touched = -1;

  @override
  Widget build(BuildContext context) {
    final summary = widget.summary;
    final entries = summary.byCategory.entries.toList();
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              centerSpaceRadius: 56,
              sectionsSpace: 2,
              // Start at 12 o'clock instead of 3 o'clock.
              startDegreeOffset: -90,
              sections: [
                for (final (index, MapEntry(key: category, value: cents))
                    in entries.indexed)
                  PieChartSectionData(
                    value: cents.toDouble(),
                    color: category.color,
                    radius: index == _touched ? 58 : 48,
                    title: _percent(cents, summary.totalCents) >= 8
                        ? '${_percent(cents, summary.totalCents)}%'
                        : '', // too small to fit a label
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    _touched =
                        event.isInterestedForInteractions && response != null
                        ? response.touchedSection?.touchedSectionIndex ?? -1
                        : -1;
                  });
                },
              ),
            ),
          ),
          // The total in the hole of the donut.
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total', style: Theme.of(context).textTheme.labelMedium),
              Text(
                formatCents(summary.totalCents),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Rounded, so the percentages may not add up to exactly 100.
int _percent(int part, int total) =>
    total == 0 ? 0 : (part * 100 / total).round();

/// One row per category: color, name, amount and share of the month.
class CategoryLegend extends StatelessWidget {
  const CategoryLegend(this.summary, {super.key});

  final MonthlySummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final MapEntry(key: category, value: cents)
            in summary.byCategory.entries)
          ListTile(
            leading: CircleAvatar(
              radius: 18,
              backgroundColor: category.color,
              foregroundColor: Colors.white,
              child: Icon(category.icon, size: 18),
            ),
            title: Text(category.label),
            subtitle: Text('${_percent(cents, summary.totalCents)}%'),
            trailing: Text(
              formatCents(cents),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
      ],
    );
  }
}
