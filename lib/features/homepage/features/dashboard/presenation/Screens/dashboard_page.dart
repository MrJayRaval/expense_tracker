import 'package:expense_tracker/config/theme_helper.dart';
import 'package:expense_tracker/features/homepage/features/dashboard/presenation/Screens/widgets/charts.dart';
import 'package:expense_tracker/features/homepage/features/dashboard/presenation/providers/dashboard_provider.dart';
import 'package:expense_tracker/features/homepage/features/history/presenation/providers/history_provider.dart';
import 'package:expense_tracker/features/homepage/features/transaction/presentaion/screens/add_transaction_page.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import 'package:expense_tracker/ui/models/trasaction_details_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<TransactionDetailsModel> transactions = [];
  List<PieChartSectionData> incomePieChartsections = [];
  List<PieChartSectionData> expensePieChartsections = [];

  List<BarChartGroupData> incomeBarChartsections = [];
  List<BarChartGroupData> expenseBarChartsections = [];

  List incomeSourceLabel = [];
  List expenseSourceLabel = [];
  // Labels for pie chart legend (category labels)
  List incomePieLabels = [];
  List expensePieLabels = [];

  @override
  void initState() {
    super.initState();
    context.read<HistoryProvider>();
    context.read<DashboardProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadCharts();
    });
  }

  Future<void> loadCharts() async {
    final provider = context.read<DashboardProvider>();
    final colors = ThemeHelper.chartColors(context);

    final incomeCategoryAnalysisList = await provider.getTransactionRatio(
      TransactionType.income,
      TransactionRatioType.category,
    );
    final newSectionsForIncomePieCart = incomeCategoryAnalysisList
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key;
          final item = entry.value;

          return PieChartSectionData(
            color: colors[index % colors.length],
            value: item.percentage,
            // hide titles on sections (we'll show a legend beside the pie)
            showTitle: false,
            radius: 25,
          );
        })
        .toList();
    // keep separate list of labels for pie legend (category list)
    final newIncomePieLabels = incomeCategoryAnalysisList
        .map((e) => e.label)
        .toList();

    final expenseCategoryAnalysisList = await provider.getTransactionRatio(
      TransactionType.expense,
      TransactionRatioType.category,
    );
    final newSectionsForExpensePieChart = expenseCategoryAnalysisList
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key;
          final item = entry.value;

          return PieChartSectionData(
            color: colors[index % colors.length],
            value: item.percentage,
            // hide titles on sections (we'll show a legend beside the pie)
            showTitle: false,
            radius: 25,
          );
        })
        .toList();
    final newExpensePieLabels = expenseCategoryAnalysisList
        .map((e) => e.label)
        .toList();

    final incomeSourceAnalysisList = await provider.getTransactionRatio(
      TransactionType.income,
      TransactionRatioType.source,
    );
    final newSectionsForIncomeBarChart = incomeSourceAnalysisList
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key;
          final item = entry.value;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: item.amount,
                width: 15,
                color: colors[index % colors.length],
              ),
            ],
          );
        })
        .toList();

    final expenseSourceAnalysisList = await provider.getTransactionRatio(
      TransactionType.expense,
      TransactionRatioType.source,
    );

    final newSectionsForExpenseBarChart = expenseSourceAnalysisList
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key;
          final item = entry.value;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: item.amount,
                width: 15,
                color: colors[index % colors.length],
              ),
            ],
          );
        })
        .toList();

    setState(() {
      incomePieChartsections = newSectionsForIncomePieCart;
      expensePieChartsections = newSectionsForExpensePieChart;
      incomeBarChartsections = newSectionsForIncomeBarChart;
      expenseBarChartsections = newSectionsForExpenseBarChart;

      incomeSourceLabel = incomeSourceAnalysisList.map((e) => e.label).toList();
      expenseSourceLabel = expenseSourceAnalysisList
          .map((e) => e.label)
          .toList();
      // assign pie labels
      incomePieLabels = newIncomePieLabels;
      expensePieLabels = newExpensePieLabels;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    transactions = context.read<HistoryProvider>().transactions;

    final incomeMax = incomeBarChartsections
        .expand((e) => e.barRods)
        .map((e) => e.toY)
        .fold(0.0, (a, b) => a > b ? a : b);
    final expenseMax = expenseBarChartsections
        .expand((e) => e.barRods)
        .map((e) => e.toY)
        .fold(0.0, (a, b) => a > b ? a : b);
    // Use individual max Y values for income and expense so each chart scales independently
    final incomeChartMaxY = incomeMax * 1.2;
    final expenseChartMaxY = expenseMax * 1.2;

    return Scaffold(
      floatingActionButton: AddTransactionFAB(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 65,
            decoration: BoxDecoration(
              border: Border.all(color: ThemeHelper.outlineVariant, width: 0.5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 5),
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Text(
                          TransactionType.income.name.capitalizeFirst!,
                          style: ThemeHelper.bodyLarge?.copyWith(
                            color: ThemeHelper.onSurface,
                          ),
                        ),
                        SizedBox(height: 3),
                        FutureBuilder<double>(
                          future: provider.totalOfTransaction(
                            TransactionType.income,
                          ),
                          builder: (context, snapshot) {
                            final val = snapshot.data ?? 0.0;
                            return Text(
                              '₹${val.toStringAsFixed(2)}',
                              style: ThemeHelper.titleMedium!.copyWith(
                                color: ThemeHelper.secondary,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                Container(width: 0.5, color: ThemeHelper.outlineVariant),

                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 5),
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Text(
                          TransactionType.expense.name.capitalizeFirst!,
                          style: ThemeHelper.bodyLarge?.copyWith(
                            color: ThemeHelper.onSurface,
                          ),
                        ),
                        SizedBox(height: 3),
                        FutureBuilder<double>(
                          future: provider.totalOfTransaction(
                            TransactionType.expense,
                          ),
                          builder: (context, snapshot) {
                            final val = snapshot.data ?? 0.0;
                            return Text(
                              '₹${val.toStringAsFixed(2)}',
                              style: ThemeHelper.titleMedium!.copyWith(
                                color: ThemeHelper.error,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 90),

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ThemeHelper.outlineVariant,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Income Overview',
                                  style: ThemeHelper.titleMedium,
                                ),
                              ],
                            ),
                          ),

                          // Compact pie + legend row
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
                                  child: CustomPieChart(
                                    sections: incomePieChartsections,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                      incomePieLabels.length,
                                      (i) {
                                        // use pie labels and pie section colors for legend
                                        final label =
                                            (i < incomePieLabels.length)
                                            ? incomePieLabels[i]
                                            : (i < incomeSourceLabel.length
                                                  ? incomeSourceLabel[i]
                                                  : '');
                                        final color =
                                            (i < incomePieChartsections.length)
                                            ? incomePieChartsections[i].color
                                            : (incomeBarChartsections.length >
                                                      i &&
                                                  incomeBarChartsections[i]
                                                      .barRods
                                                      .isNotEmpty)
                                            ? incomeBarChartsections[i]
                                                  .barRods
                                                  .first
                                                  .color
                                            : ThemeHelper.outlineVariant;
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 14,
                                                height: 14,
                                                decoration: BoxDecoration(
                                                  color: color,
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  label.toString(),
                                                  style: ThemeHelper.bodyMedium,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Bar chart below (made a bit shorter to fit layout)
                          SizedBox(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                height: 300,
                                child: CustomBarChart(
                                  labels: incomeSourceLabel,
                                  sections: incomeBarChartsections,
                                  maxY: incomeChartMaxY,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30),

                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ThemeHelper.outlineVariant,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expense Overview',
                                  style: ThemeHelper.titleMedium,
                                ),
                              ],
                            ),
                          ),

                          // Compact pie + legend row (expense)
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
                                  child: CustomPieChart(
                                    sections: expensePieChartsections,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                      expensePieLabels.length,
                                      (i) {
                                        final label =
                                            (i < expensePieLabels.length)
                                            ? expensePieLabels[i]
                                            : (i < expenseSourceLabel.length
                                                  ? expenseSourceLabel[i]
                                                  : '');
                                        final color =
                                            (i < expensePieChartsections.length)
                                            ? expensePieChartsections[i].color
                                            : (expenseBarChartsections.length >
                                                      i &&
                                                  expenseBarChartsections[i]
                                                      .barRods
                                                      .isNotEmpty)
                                            ? expenseBarChartsections[i]
                                                  .barRods
                                                  .first
                                                  .color
                                            : ThemeHelper.outlineVariant;
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 14,
                                                height: 14,
                                                decoration: BoxDecoration(
                                                  color: color,
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  label.toString(),
                                                  style: ThemeHelper.bodyMedium,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Bar chart below (expense)
                          SizedBox(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                height: 240,
                                child: CustomBarChart(
                                  labels: expenseSourceLabel,
                                  sections: expenseBarChartsections,
                                  maxY: expenseChartMaxY,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
}
