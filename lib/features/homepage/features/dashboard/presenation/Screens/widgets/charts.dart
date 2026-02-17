import 'package:expense_tracker/config/theme_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomPieChart extends StatelessWidget {
  final List<PieChartSectionData> sections;
  const CustomPieChart({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    if (sections.isEmpty) {
      return Center(
        child: Container(
          width: 200, // or size
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ThemeHelper.outlineVariant.withValues(alpha: 0.2),
          ),
          child: const Center(child: Text("No Data")),
        ),
      );
    }
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        startDegreeOffset: 0,
        sections: sections,
        titleSunbeamLayout: false,
        centerSpaceRadius: 45,
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

class CustomBarChart extends StatelessWidget {
  final List<BarChartGroupData> sections;
  final List labels;
  final double? maxY;

  const CustomBarChart({
    super.key,
    required this.sections,
    required this.labels,
    this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    if (sections.isEmpty) {
      return Center(child: Text("No Data", style: ThemeHelper.bodyMedium));
    }
    double calculatedMaxY =
        maxY ??
        (sections.isEmpty
            ? 100
            : sections
                      .expand((g) => g.barRods)
                      .map((r) => r.toY)
                      .reduce((a, b) => a > b ? a : b) *
                  1.2);

    if (calculatedMaxY == 0) calculatedMaxY = 10;

    // Calculate a reasonable interval (e.g., 5 steps)
    double interval = calculatedMaxY / 5;
    if (interval <= 0) interval = 1;

    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40, // Ensure space for bottom labels
              getTitlesWidget: (value, meta) {
                final index = value.toInt();

                if (index < 0 || index >= labels.length) {
                  return const SizedBox();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    labels[index],
                    style: ThemeHelper.titleSmall, // Adjust font size if needed
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitleAlignment: SideTitleAlignment.border,
            axisNameSize: 16,
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45, // Ensure space for left labels
              interval: interval, // Prevent label stacking
              getTitlesWidget: (value, meta) {
                String text;
                if (value >= 1000000) {
                  text =
                      '${(value / 1000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}M';
                } else if (value >= 1000) {
                  text =
                      '${(value / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}k';
                } else {
                  text = value % 1 == 0
                      ? value.toInt().toString()
                      : value.toStringAsFixed(1);
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(text, style: ThemeHelper.bodySmall),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: sections,
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: calculatedMaxY,
      ),
    );
  }
}
