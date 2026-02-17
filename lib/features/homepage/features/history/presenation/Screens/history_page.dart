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
import 'package:expense_tracker/ui/models/trasaction_details_model.dart';

enum SortOption { newest, oldest, amountHigh, amountLow }

class HistoryPage extends StatefulWidget {
  final TransactionType? transactionType;
  const HistoryPage({super.key, this.transactionType});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late TransactionType transactionType;
  SortOption _sortOption = SortOption.newest;
  final Set<String> _selectedCategories = {};

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
                _selectedCategories.clear(); // Clear filter on type change
              });
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.filter_list, size: 16),
                  label: const Text('Filter'),
                  onPressed: () {
                    final allTransactions =
                        transactionType == TransactionType.expense
                        ? provider.expenseTransactions
                        : provider.incomeTransactions;
                    final categories = allTransactions
                        .map((e) => e.transactionCategoryLabel)
                        .toSet()
                        .toList();
                    _showFilterDialog(categories);
                  },
                ),
                const SizedBox(width: 10),
                ActionChip(
                  avatar: const Icon(Icons.sort, size: 16),
                  label: const Text('Sort'),
                  onPressed: _showSortDialog,
                ),
              ],
            ),
          ),

          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                ? Center(child: Text(provider.error!))
                : ValueListenableBuilder<Box>(
                    key: ValueKey(transactionType.name),
                    valueListenable: Hive.box(
                      transactionType.name,
                    ).listenable(),
                    builder: (context, box, _) {
                      var transactions =
                          transactionType == TransactionType.expense
                          ? provider.expenseTransactions
                          : provider.incomeTransactions;

                      // 1. Filter
                      if (_selectedCategories.isNotEmpty) {
                        transactions = transactions
                            .where(
                              (t) => _selectedCategories.contains(
                                t.transactionCategoryLabel,
                              ),
                            )
                            .toList();
                      }

                      if (transactions.isEmpty) {
                        return EmptyStateWidget(
                          title: "No ${transactionType.name.capitalize} Found",
                          description:
                              "Try adjusting your filters or add new records.",
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

                      // 2. Sort & Group
                      final isGrouped =
                          _sortOption == SortOption.newest ||
                          _sortOption == SortOption.oldest;

                      if (!isGrouped) {
                        // Flat List (Amount Sort)
                        final sortedList = List<TransactionDetailsModel>.from(
                          transactions,
                        );
                        if (_sortOption == SortOption.amountHigh) {
                          sortedList.sort(
                            (a, b) => b.amount.compareTo(a.amount),
                          );
                        } else {
                          sortedList.sort(
                            (a, b) => a.amount.compareTo(b.amount),
                          );
                        }

                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: sortedList.length,
                          itemBuilder: (context, index) {
                            final transaction = sortedList[index];
                            return _buildTransactionItem(transaction, context);
                          },
                        );
                      } else {
                        // Grouped List (Date Sort)
                        final grouped = provider.groupByDate(transactions);
                        final sortedDates = grouped.keys.toList();
                        if (_sortOption == SortOption.newest) {
                          sortedDates.sort((a, b) => b.compareTo(a));
                        } else {
                          sortedDates.sort((a, b) => a.compareTo(b));
                        }

                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: grouped.length,
                          itemBuilder: (BuildContext context, int index) {
                            final date = sortedDates[index];
                            final dayTransaction = grouped[date]!;

                            return Column(
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
                                  (transaction) => _buildTransactionItem(
                                    transaction,
                                    context,
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    TransactionDetailsModel transaction,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) {
          return HistoryDetailsPage(
            context: context,
            deleteButtonFunction: () {
              context.read<HistoryProvider>().deleteParticularTransaction(
                transactionType,
                transaction.id,
              );
              Navigator.pop(context);
            },
            title: "${transactionType.name.capitalize}",
            transaction: transaction,
            transactionType: transactionType,
          );
        },
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: HistoryTile(
          transactionCategoryIcon: transaction.transactionCategoryIcon,
          transactionCategoryLabel: transaction.transactionCategoryLabel,
          transactionSourceLabel: transaction.transactionSourceLabel,
          transactionSourceIcon: transaction.transactionSourceIcon,
          amount: transaction.amount,
          color: transactionType == TransactionType.income
              ? ThemeHelper.primary
              : ThemeHelper.error,
        ),
      ),
    );
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sort By", style: ThemeHelper.titleMedium),
              const SizedBox(height: 10),
              _buildSortOption(SortOption.newest, "Date (Newest First)"),
              _buildSortOption(SortOption.oldest, "Date (Oldest First)"),
              _buildSortOption(SortOption.amountHigh, "Amount (High to Low)"),
              _buildSortOption(SortOption.amountLow, "Amount (Low to High)"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(SortOption option, String label) {
    return RadioListTile<SortOption>(
      title: Text(label),
      value: option,
      groupValue: _sortOption,
      onChanged: (value) {
        if (value != null) {
          setState(() => _sortOption = value);
          Navigator.pop(context);
        }
      },
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showFilterDialog(List<String> categories) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filter by Category",
                        style: ThemeHelper.titleMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() => _selectedCategories.clear());
                          setModalState(() {});
                        },
                        child: const Text("Clear"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: categories.map((cat) {
                      final isSelected = _selectedCategories.contains(cat);
                      return FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedCategories.add(cat);
                            } else {
                              _selectedCategories.remove(cat);
                            }
                          });
                          setModalState(() {});
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        );
      },
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
