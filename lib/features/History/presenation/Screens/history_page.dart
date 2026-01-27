import 'package:expense_tracker/config/theme_helper.dart';
import 'package:expense_tracker/features/History/presenation/Screens/history_details_page.dart';
import 'package:expense_tracker/features/History/presenation/Screens/history_tile.dart';
import 'package:expense_tracker/features/History/presenation/providers/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late bool isExpense;

  @override
  void initState() {
    super.initState();
    isExpense = false;

    // Fetch incomes once the widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HistoryProvider>();
      if (provider.incomes.isEmpty) {
        provider.getIncomes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();

    void deleteParticularIncome(String id) {
      context.read<HistoryProvider>().deleteParticularIncome(id);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      // Expense should set isExpense = true
                      isExpense = true;
                    });
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: (isExpense)
                            ? BorderSide(width: 3, color: ThemeHelper.primary)
                            : BorderSide.none,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Expense',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: ThemeHelper.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Vertical divider between the two tabs
              Container(
                width: 1,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: Theme.of(context).dividerColor,
              ),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      // Income should set isExpense = false
                      isExpense = false;
                    });
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: (!isExpense)
                            ? BorderSide(width: 3, color: ThemeHelper.primary)
                            : BorderSide.none,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Income',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: ThemeHelper.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Show loading / error / empty states, and use provider.incomes (watched) so UI rebuilds
          Expanded(
            child: provider.isLoading
                ? Center(child: CircularProgressIndicator())
                : provider.error != null
                ? Center(child: Text(provider.error!))
                : provider.incomes.isEmpty
                ? Center(child: Text('No history found'))
                : ListView.builder(
                    itemCount: provider.incomes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) {
                            return HistoryDetailsPage(
                              isThisExpense: true,
                              context: context,
                              deleteButtonFunction: () {
                               deleteParticularIncome(
                                  provider.incomes[index].id,
                                );

                                Navigator.pop(context);
                              },
                              title: 'Expense',
                              income: provider.incomes[index],
                            );
                          },
                        ),
                        child: HistoryTile(
                          incomeTypeIcon:
                              provider.incomes[index].incomeTypeIcon,
                          incomeTypeLabel:
                              provider.incomes[index].incomeTypeLabel,
                          incomeSourceLabel:
                              provider.incomes[index].incomeSourceLabel,
                          incomeSourceIcon:
                              provider.incomes[index].incomeSourceIcon,
                          amount: provider.incomes[index].amount,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
