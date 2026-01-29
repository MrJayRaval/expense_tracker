import '../../../../config/theme_helper.dart';
import 'history_details_page.dart';
import 'history_tile.dart';
import '../providers/history_provider.dart';
import '../../../income/domain/entity/income_details_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
    final grouped = provider.groupByDate(provider.incomes);
    final sortedDates = grouped.keys.toList()..sort((a,b) => b.compareTo(a));

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

          // Show loading / error / empty states, and listen to local Hive box so UI rebuilds when local data changes
          // Expanded(
          //   child: provider.isLoading
          //       ? Center(child: CircularProgressIndicator())
          //       : provider.error != null
          //       ? Center(child: Text(provider.error!))
          //       : ValueListenableBuilder<Box>(
          //           valueListenable: Hive.box('incomes').listenable(),
          //           builder: (context, box, _) {
          //             final items = box.values.toList();
          //             if (items.isEmpty) {
          //               return Center(child: Text('No history found'));
          //             }

          //             return ListView.builder(
          //               itemCount: items.length,
          //               itemBuilder: (BuildContext context, int index) {
          //                 final raw = items[index];
          //                 final Map<String, dynamic> json = raw is Map
          //                     ? Map<String, dynamic>.from(raw)
          //                     : {};
          //                 final String id = (json['id'] ?? '').toString();
          //                 final income = IncomeDetailsModel.fromJson(json, id);

          //                 return GestureDetector(
          //                   onTap: () => showDialog(
          //                     context: context,
          //                     builder: (context) {
          //                       return HistoryDetailsPage(
          //                         isThisExpense: true,
          //                         context: context,
          //                         deleteButtonFunction: () {
          //                           deleteParticularIncome(income.id);
          //                           Navigator.pop(context);
          //                         },
          //                         title: 'Expense',
          //                         income: income,
          //                       );
          //                     },
          //                   ),
          //                   child: HistoryTile(
          //                     incomeTypeIcon: income.incomeTypeIcon,
          //                     incomeTypeLabel: income.incomeTypeLabel,
          //                     incomeSourceLabel: income.incomeSourceLabel,
          //                     incomeSourceIcon: income.incomeSourceIcon,
          //                     amount: income.amount,
          //                   ),
          //                 );
          //               },
          //             );
          //           },
          //         ),
          // ),

          isExpense 
            ? Text('Expense') : Expanded(
            child: provider.isLoading
                ? Center(child: CircularProgressIndicator())
                : provider.error != null
                ? Center(child: Text(provider.error!))
                : ValueListenableBuilder<Box>(
                    valueListenable: Hive.box('incomes').listenable(),
                    builder: (context, box, _) {
                      final items = box.values.toList();
                      if (items.isEmpty) {
                        return Center(child: Text('No history found'));
                      }

                      return ListView.builder(
                        itemCount: grouped.length,
                        itemBuilder: (BuildContext context, int index) {

                          final date = sortedDates[index];
                          final dayIncomes = grouped[date]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(DateFormat("MMM d, yyyy").format(date), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: ThemeHelper.onSurface),),
                              Divider(),
                              
                              ...dayIncomes.map((income) => GestureDetector(
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (context) {
                                    return HistoryDetailsPage(
                                      isThisExpense: true,
                                      context: context,
                                      deleteButtonFunction: () {
                                        deleteParticularIncome(income.id);
                                        Navigator.pop(context);
                                      },
                                      title: 'Expense',
                                      income: income,
                                    );
                                  },
                                ),
                                child: HistoryTile(
                                  incomeTypeIcon: income.incomeTypeIcon,
                                  incomeTypeLabel: income.incomeTypeLabel,
                                  incomeSourceLabel: income.incomeSourceLabel,
                                  incomeSourceIcon: income.incomeSourceIcon,
                                  amount: income.amount,
                                ),
                              ),),

                              SizedBox(height: 10,)
                              
                            ],
                          );
                        },
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
