import 'package:expense_tracker/config/theme_helper.dart';
import 'package:expense_tracker/features/homepage/features/dashboard/presenation/Screens/widgets/charts.dart';
import 'package:expense_tracker/features/homepage/features/dashboard/presenation/Screens/widgets/empty_dashboard_state.dart';
import 'package:expense_tracker/features/homepage/features/dashboard/presenation/providers/dashboard_provider.dart';
import 'package:expense_tracker/features/homepage/features/history/presenation/providers/history_provider.dart';
import 'package:expense_tracker/features/homepage/features/transaction/presentaion/screens/add_transaction_page.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // No manual loading logic here.
    // ProxyProvider handles the data sync between History and Dashboard.
  }

  @override
  Widget build(BuildContext context) {
    // 1. Listen to Providers
    final history = context.watch<HistoryProvider>();
    final dashboard = context.watch<DashboardProvider>();
    final colors = ThemeHelper.chartColors(context);

    // 2. Handle Initial Loading State
    if (history.isLoading && history.incomeTransactions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!dashboard.hasAnyTransaction) {
      return Scaffold(
        floatingActionButton: const AddTransactionFAB(),
        body: const EmptyDashboardState(),
      );
    }

    // 3. Prepare Chart Data on the fly
    final incomePieSections = _generatePieSections(
      dashboard.incomeDistribution,
      colors,
    );
    final expensePieSections = _generatePieSections(
      dashboard.expenseDistribution,
      colors,
    );

    final incomeBarGroups = _generateBarGroups(
      dashboard.incomeSourceDistribution,
      colors,
    );
    final expenseBarGroups = _generateBarGroups(
      dashboard.expenseSourceDistribution,
      colors,
    );

    return Scaffold(
      floatingActionButton: AddTransactionFAB(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month Selector
          _buildMonthSelector(dashboard),

          // Header Totals Section
          _buildTotalsHeader(dashboard),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 90),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // Income Overview Card

                    // Expense Overview Card
                    _buildOverviewCard(
                      title: 'Expense Overview',
                      pieSections: expensePieSections,
                      pieLabels: dashboard.expenseDistribution
                          .map((e) => e.label)
                          .toList(),
                      barSections: expenseBarGroups,
                      barLabels: dashboard.expenseSourceDistribution
                          .map((e) => e.label)
                          .toList(),
                      maxY: _getMaxY(expenseBarGroups),
                    ),

                    const SizedBox(height: 30),

                    _buildOverviewCard(
                      title: 'Income Overview',
                      pieSections: incomePieSections,
                      pieLabels: dashboard.incomeDistribution
                          .map((e) => e.label)
                          .toList(),
                      barSections: incomeBarGroups,
                      barLabels: dashboard.incomeSourceDistribution
                          .map((e) => e.label)
                          .toList(),
                      maxY: _getMaxY(incomeBarGroups),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildMonthSelector(DashboardProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      color: ThemeHelper.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              final newMonth = DateTime(
                provider.selectedMonth.year,
                provider.selectedMonth.month - 1,
              );
              provider.updateMonth(newMonth);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: ThemeHelper.onSurface,
            ),
          ),
          Text(
            DateFormat('MMMM, yyyy').format(provider.selectedMonth),
            style: ThemeHelper.titleMedium!.copyWith(
              color: ThemeHelper.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {
              final newMonth = DateTime(
                provider.selectedMonth.year,
                provider.selectedMonth.month + 1,
              );
              provider.updateMonth(newMonth);
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: ThemeHelper.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsHeader(DashboardProvider provider) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        border: Border.all(color: ThemeHelper.outlineVariant, width: 0.5),
      ),
      child: Row(
        children: [
          _buildTotalItem(
            label: TransactionType.income.name.capitalizeFirst!,
            amount: provider.incomeTotal,
            color: ThemeHelper
                .error, // Wait, is income typically error color? Usually Green. But using exiting code.
          ),
          Container(width: 0.5, color: ThemeHelper.outlineVariant),
          _buildTotalItem(
            label: TransactionType.expense.name.capitalizeFirst!,
            amount: provider.expenseTotal,
            color: ThemeHelper.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalItem({
    required String label,
    required double amount,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: ThemeHelper.bodyLarge?.copyWith(
              color: ThemeHelper.onSurface,
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: ThemeHelper.titleMedium!.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard({
    required String title,
    required List<PieChartSectionData> pieSections,
    required List<String> pieLabels,
    required List<BarChartGroupData> barSections,
    required List<String> barLabels,
    required double maxY,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ThemeHelper.outlineVariant, width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(title, style: ThemeHelper.titleMedium),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CustomPieChart(sections: pieSections),
                ),
                const SizedBox(width: 12),
                Expanded(child: _buildLegend(pieLabels, pieSections)),
              ],
            ),
          ),
          SizedBox(
            height: 250,
            child: CustomBarChart(
              labels: barLabels,
              sections: barSections,
              maxY: maxY,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(List<String> labels, List<PieChartSectionData> sections) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(labels.length, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: sections[i].color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  labels[i],
                  style: ThemeHelper.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // --- Logic Helpers ---

  List<PieChartSectionData> _generatePieSections(
    List distribution,
    List<Color> colors,
  ) {
    return distribution.asMap().entries.map((entry) {
      return PieChartSectionData(
        value: entry.value.percentage,
        color: colors[entry.key % colors.length],
        showTitle: false,
        radius: 25,
      );
    }).toList();
  }

  List<BarChartGroupData> _generateBarGroups(
    List distribution,
    List<Color> colors,
  ) {
    return distribution.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.amount,
            width: 15,
            color: colors[entry.key % colors.length],
          ),
        ],
      );
    }).toList();
  }

  double _getMaxY(List<BarChartGroupData> sections) {
    if (sections.isEmpty) return 100.0;
    double max = 0;
    for (var group in sections) {
      for (var rod in group.barRods) {
        if (rod.toY > max) max = rod.toY;
      }
    }
    return max == 0 ? 100.0 : max * 1.2;
  }
}
