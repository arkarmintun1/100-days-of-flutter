import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../formatting/money.dart';
import '../l10n.dart';

/// Spending per day of the month, as bars.
class DailyBarChart extends StatelessWidget {
  const DailyBarChart(this.dailyCents, {super.key});

  /// [0] is the 1st of the month.
  final List<int> dailyCents;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    // Day 97: the bars are only drawn: a screen reader gets a summary.
    var top = 0;
    for (var i = 1; i < dailyCents.length; i++) {
      if (dailyCents[i] > dailyCents[top]) top = i;
    }
    final summary = dailyCents.isEmpty || dailyCents[top] == 0
        ? l10n.dailyChartEmpty
        : l10n.dailyChartSummary(
            top + 1,
            formatCents(dailyCents[top], l10n.localeName),
          );
    return Semantics(
      container: true,
      label: summary,
      // The axis numbers alone ("1", "8", "50") would only be noise.
      child: ExcludeSemantics(
        child: SizedBox(
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
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    // No label at the top end of the axis (e.g. "87.3"), only
                    // at the grid lines' intervals.
                    maxIncluded: false,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    // Label the 1st, 8th, 15th, 22nd and 29th only.
                    getTitlesWidget: (value, meta) => SideTitleWidget(
                      meta: meta,
                      child: Text(
                        (value.toInt() - 1) % 7 == 0
                            ? formatNumber(
                                value.toInt(),
                                context.l10n.localeName,
                              )
                            : '',
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
                        '${context.l10n.dayOfMonth(group.x)}\n'
                        '${formatCents(dailyCents[group.x - 1], context.l10n.localeName)}',
                        TextStyle(color: colors.onInverseSurface),
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
