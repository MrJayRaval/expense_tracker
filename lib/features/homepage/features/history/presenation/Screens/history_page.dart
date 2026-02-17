import 'package:expense_tracker/ui/models/enum.dart';
import '../../../../../../ui/components/segmented_toggle.dart';
import 'package:get/get.dart';

import '../../../../../../config/theme_helper.dart';
import 'history_details_page.dart';
import 'history_tile.dart';
import '../providers/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker/ui/components/empty_state_widget.dart';
import '../../../transaction/presentaion/screens/add_transaction_page.dart';
import '../../../../../../ui/components/theme_provider.dart';

class HistoryPage extends StatefulWidget {
  final TransactionType? transactionType;
  const HistoryPage({super.key, this.transactionType});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late TransactionType transactionType;

  @override
  void initState() {
    super.initState();
    transactionType = widget.transactionType ?? TransactionType.expense;

    // Fetch transactions once the widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();
    final grouped = provider.groupByDate(
      transactionType == TransactionType.expense
          ? provider.expenseTransactions
          : provider.incomeTransactions,
    );
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
          SegmentedToggle<TransactionType>(
            options: {
              TransactionType.expense: 'Expense',
              TransactionType.income: 'Income',
            },
            selectedValue: transactionType,
            onValueChanged: (value) {
              setState(() {
                transactionType = value;
              });
            },
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
                      // Re-calculate grouped data inside builder to ensure it's fresh
                      final grouped = provider.groupByDate(
                        transactionType == TransactionType.expense
                            ? provider.expenseTransactions
                            : provider.incomeTransactions,
                      );

                      final sortedDates = grouped.keys.toList()
                        ..sort((a, b) => b.compareTo(a));

                      if (grouped.isEmpty) {
                        return EmptyStateWidget(
                          title:
                              "No ${transactionType.name.capitalize} History",
                          description:
                              "You haven't added any ${transactionType.name} records yet.",
                          icon: Icons.history_edu_outlined,
                          actionLabel: "Add ${transactionType.name.capitalize}",
                          onAction: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddTransactionPage(
                                  transactionType: transactionType,
                                ),
                              ),
                            );
                          },
                        );
                      }

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: grouped.length,
                        itemBuilder: (BuildContext context, int index) {
                          final date = sortedDates[index];
                          final dayTransaction = grouped[date]!;
                          final isAnimationsEnabled = context
                              .read<ThemeProvider>()
                              .isAnimationsEnabled;

                          Widget item = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Text(
                                  DateFormat("MMM d, yyyy").format(date),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: ThemeHelper.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              const Divider(),
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: HistoryTile(
                                      transactionCategoryIcon:
                                          transaction.transactionCategoryIcon,
                                      transactionCategoryLabel:
                                          transaction.transactionCategoryLabel,
                                      transactionSourceLabel:
                                          transaction.transactionSourceLabel,
                                      transactionSourceIcon:
                                          transaction.transactionSourceIcon,
                                      amount: transaction.amount,
                                      color:
                                          transactionType ==
                                              TransactionType.income
                                          ? ThemeHelper.primary
                                          : ThemeHelper.error,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );

                          if (isAnimationsEnabled) {
                            return TweenAnimationBuilder<double>(
                              duration: Duration(
                                milliseconds: 400 + (index * 100),
                              ),
                              tween: Tween(begin: 0.0, end: 1.0),
                              curve: Curves.easeOutQuart,
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, 30 * (1 - value)),
                                    child: child,
                                  ),
                                );
                              },
                              child: item,
                            );
                          } else {
                            return item;
                          }
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

// class HistoryFAB extends StatefulWidget {
//   const HistoryFAB({super.key});

//   @override
//   State<HistoryFAB> createState() => _HistoryFABState();
// }

// class _HistoryFABState extends State<HistoryFAB> {
//   final addCategoryController = TextEditingController();

//   @override
//   void dispose() {
//     addCategoryController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton.extended(
//       backgroundColor: ThemeHelper.onSurface,
//       onPressed: () {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             shape: RoundedRectangleBorder(
//               side: BorderSide(color: ThemeHelper.outline),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             titlePadding: EdgeInsets.only(top: 20, left: 20, right: 20),
//             title: Text('Remove All History'),
//             actions: [
//               TextButton(onPressed: () {
//                 Navigator.pop(context);
//               }, child: Text('Cancel')),
//               TextButton(onPressed: () async {
//                 debugPrint("${await Hive.box('expense').clear()} entry removed)");
//                 debugPrint("${await Hive.box('income').clear()} entry removed)");
//                 Navigator.pop(context);
//               }, child: Text('Confirm')),
//             ],
//           ),
//         );

//       },
//       icon: Icon(Icons.delete, color: ThemeHelper.error),
//       label: Text(
//         'Remove All History',
//         style: TextStyle(color: ThemeHelper.surface),
//       ),
//     );
//   }
// }
