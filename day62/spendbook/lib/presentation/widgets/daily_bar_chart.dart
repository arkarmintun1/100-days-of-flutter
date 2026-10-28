import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../formatting/money.dart';

/// Spending per day of the month, as bars.
class DailyBarChart extends StatelessWidget {
  const DailyBarChart(this.dailyCents, {super.key});

  /// [0] is the 1st of the month.
  final List<int> dailyCents;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          barGroups: [
            for (final (index, cents) in dailyCents.indexed)
              BarChartGroupData(
                x: index + 1, // the day of the month
                barRods: [
                  BarChartRodData(
                    // Dollars on the axis; the bars don't need cent accuracy.
                    toY: cents / 100,
                    color: colors.primary,
                    width: 6,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(3),
                    ),
                  ),
                ],
              ),
          ],
          gridData: const FlGridData(drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                // Label the 1st, 8th, 15th, 22nd and 29th only.
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    (value.toInt() - 1) % 7 == 0 ? '${value.toInt()}' : '',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                  BarTooltipItem(
                    'Day ${group.x}\n'
                    '${formatCents(dailyCents[group.x - 1])}',
                    TextStyle(color: colors.onInverseSurface),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
