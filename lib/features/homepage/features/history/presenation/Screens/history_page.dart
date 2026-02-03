import 'package:expense_tracker/ui/models/enum.dart';
import 'package:get/get.dart';

import '../../../../../../config/theme_helper.dart';
import 'history_details_page.dart';
import 'history_tile.dart';
import '../providers/history_provider.dart';
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
  late TransactionType transactionType;

  @override
  void initState() {
    super.initState();
    transactionType = TransactionType.income;

    // Fetch transactions once the widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HistoryProvider>();
      if (provider.transactions.isEmpty) {
        provider.getTransactions(transactionType);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();
    final grouped = provider.groupByDate(provider.transactions);
    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    void deleteParticularTransaction(String id) {
      context.read<HistoryProvider>().deleteParticularTransaction(
        transactionType,
        id,
      );
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
                      transactionType = TransactionType.expense;
                      provider.getTransactions(transactionType);
                    });
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: (transactionType == TransactionType.expense)
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
                      transactionType = TransactionType.income;
                      provider.getTransactions(transactionType);
                    });
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: (transactionType == TransactionType.income)
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

          Expanded(
            child: provider.isLoading
                ? Center(child: CircularProgressIndicator())
                : provider.error != null
                ? Center(child: Text(provider.error!))
                : ValueListenableBuilder<Box>(
                    key: ValueKey(transactionType.name),
                    valueListenable: Hive.box(
                      transactionType.name,
                    ).listenable(),
                    builder: (context, box, _) {
                      final items = box.values.toList();
                      if (items.isEmpty) {
                        return Center(child: Text('No history found'));
                      }

                      return ListView.builder(
                        itemCount: grouped.length,
                        itemBuilder: (BuildContext context, int index) {
                          final date = sortedDates[index];
                          final dayTransaction = grouped[date]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat("MMM d, yyyy").format(date),
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(color: ThemeHelper.onSurface),
                              ),
                              Divider(),

                              ...dayTransaction.map(
                                (transaction) => GestureDetector(
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) {
                                      return HistoryDetailsPage(
                                        context: context,
                                        deleteButtonFunction: () {
                                          deleteParticularTransaction(
                                            transaction.id,
                                          );
                                          Navigator.pop(context);
                                        },
                                        title:
                                            "${transactionType.name.capitalize}",
                                        transaction: transaction,
                                        transactionType: transactionType,
                                      );
                                    },
                                  ),
                                  child: HistoryTile(
                                    transactionCategoryIcon:
                                        transaction.transactionCategoryIcon,
                                    transactionCategoryLabel:
                                        transaction.transactionCategoryLabel,
                                    transactionSourceLabel:
                                        transaction.transactionSourceLabel,
                                    transactionSourceIcon:
                                        transaction.transactionSourceLabel,
                                    amount: transaction.amount,
                                  ),
                                ),
                              ),

                              SizedBox(height: 10),
                            ],
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class HistoryFAB extends StatefulWidget {
  const HistoryFAB({super.key});

  @override
  State<HistoryFAB> createState() => _HistoryFABState();
}

class _HistoryFABState extends State<HistoryFAB> {
  final addCategoryController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    addCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: ThemeHelper.onSurface,
      onPressed: () async {
        debugPrint("${await Hive.box('expense').clear()} entry removed)");
        debugPrint("${await Hive.box('income').clear()} entry removed)");
      },
      icon: Icon(Icons.delete, color: ThemeHelper.error),
      label: Text(
        'Remove All History',
        style: TextStyle(color: ThemeHelper.surface),
      ),
    );
  }
}
