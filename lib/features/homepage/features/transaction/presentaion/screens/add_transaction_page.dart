import 'package:expense_tracker/features/homepage/features/transaction/domain/entity/transaction_categoey_model.dart';
import 'package:expense_tracker/features/homepage/features/transaction/presentaion/screens/transaction_category.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import 'package:get/get_utils/get_utils.dart';

import '../../../../../../config/theme_helper.dart';
import '../../../history/presenation/providers/history_provider.dart';
import '../../../../presentation/screens/homepage.dart';
import '../../../../../../ui/models/trasaction_details_model.dart';
import '../../domain/entity/transaction_source_model.dart';
import '../provider/transaction_provider.dart';
import 'transaction_source.dart';
import '../../../../../../ui/components/button.dart';
import '../../../../../../ui/models/calc_input_model.dart';
import '../../../../../../ui/components/onscreen_keyboard.dart';
import '../../../../../../ui/components/raise_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTransactionPage extends StatefulWidget {
  final TransactionType transactionType;
  final TransactionDetailsModel? transaction;
  final bool? isEditMode;
  final String? transactionID;
  const AddTransactionPage({
    super.key,
    this.transaction,
    this.isEditMode = false,
    this.transactionID = "",
    required this.transactionType,
  });

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TransactionInput input;

  int? selectedTransactionIndex;
  TransactionSource? selectedTransactionCategory;
  TransactionCategory? selectedTransactionSource;

  late TransactionType transactionType;

  @override
  void initState() {
    super.initState();

    transactionType = widget.transactionType;

    if (widget.transaction != null) {
      final i = widget.transaction!;

      input = TransactionInput(
        notes: i.notes,
        amount: i.amount,
        dateTime: i.dateTime,
      );
      selectedTransactionCategory = TransactionSource(
        label: i.transactionCategoryLabel,
        icon: i.transactionCategoryIcon,
      );
      selectedTransactionSource = TransactionCategory(
        label: i.transactionSourceLabel,
        icon: i.transactionSourceIcon,
      );
    } else {
      input = TransactionInput(notes: '', amount: 0, dateTime: DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final error = provider.error;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(buildErrorSnackBar(error));
        provider.clearError(); // IMPORTANT
      }
    });

    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              transactionType = TransactionType.expense;
                            });
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    (transactionType == TransactionType.expense)
                                    ? BorderSide(
                                        width: 3,
                                        color: ThemeHelper.primary,
                                      )
                                    : BorderSide.none,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Expense',
                                style: Theme.of(context).textTheme.titleLarge!
                                    .copyWith(color: ThemeHelper.onSurface),
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
                            });
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    (transactionType == TransactionType.income)
                                    ? BorderSide(
                                        width: 3,
                                        color: ThemeHelper.primary,
                                      )
                                    : BorderSide.none,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Income',
                                style: Theme.of(context).textTheme.titleLarge!
                                    .copyWith(color: ThemeHelper.onSurface),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustOutlinedButton(
                          label:
                              selectedTransactionCategory?.label ??
                              '${transactionType.name.capitalize} Category',
                          textStyle: Theme.of(context).textTheme.bodyMedium!,
                          borderRadius: 6,
                          borderWidth: 1.5,
                          borderColor: ThemeHelper.outline,
                          function: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      Icon(Icons.playlist_add_check_rounded),
                                      SizedBox(width: 15),
                                      Text("Choose Category"),
                                    ],
                                  ),

                                  content: SizedBox(
                                    width: double.maxFinite,
                                    height: 300,
                                    child: TransactionCategoryWidget(
                                      onItemSelected: (value) {
                                        setState(() {
                                          selectedTransactionCategory =
                                              TransactionSource(
                                                label: value['label'],
                                                icon: value['icon'],
                                              );
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      SizedBox(width: 10),

                      Expanded(
                        child: CustOutlinedButton(
                          label:
                              selectedTransactionSource?.label ??
                              '${transactionType.name.capitalize} Source',
                          textStyle: ThemeHelper.bodyMedium!,
                          borderRadius: 6,
                          borderWidth: 1.5,
                          borderColor: ThemeHelper.outline,
                          function: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      Icon(Icons.playlist_add_check_rounded),
                                      SizedBox(width: 15),
                                      Text("Choose Source"),
                                    ],
                                  ),

                                  content: SizedBox(
                                    width: double.maxFinite,
                                    height: 300,
                                    child: TransactionSourceWidget(
                                      transactionType: transactionType,
                                      onItemSelected: (value) {
                                        setState(() {
                                          selectedTransactionSource =
                                              TransactionCategory(
                                                label: value['label'],
                                                icon: value['icon'],
                                              );
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  OnScreenKeyBoard(
                    isEditMode: widget.isEditMode,
                    notes: input.notes,
                    calculationDisplay: input.amount.toString(),
                    selectedDate: input.dateTime,
                    selectedTime: TimeOfDay.fromDateTime(input.dateTime),
                    onCompleted: (TransactionInput value) {
                      input = value;
                    },
                  ),

                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: provider.isLoading
                          ? ThemeHelper.outline
                          : ThemeHelper.secondary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          List<String> errors = [];
                          if ((input.notes).isEmpty) {
                            // TransactionInput fields are immutable/final. Create a new
                            // TransactionInput with the updated notes value instead of
                            // trying to assign to a final field.
                            input = TransactionInput(
                              notes: "Empty",
                              amount: input.amount,
                              dateTime: input.dateTime,
                            );
                          }
                          if ((input.amount) <= 0) {
                            errors.add('Enter valid Amount');
                          }

                          if ((selectedTransactionCategory?.label ?? '')
                              .isEmpty) {
                            errors.add(
                              'Select ${transactionType.name.capitalize} Category',
                            );
                          }

                          if ((selectedTransactionSource?.label ?? '')
                              .isEmpty) {
                            errors.add(
                              'Select ${transactionType.name.capitalize} Source',
                            );
                          }

                          if (errors.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: errors
                                      .map(
                                        (e) => Text(
                                          '• $e',
                                          style: ThemeHelper.bodyMedium!
                                              .copyWith(
                                                color: ThemeHelper
                                                    .onErrorContainer,
                                              ),
                                        ),
                                      )
                                      .toList(),
                                ),
                                backgroundColor: ThemeHelper.errorContainer,
                                showCloseIcon: true,
                                closeIconColor: ThemeHelper.onErrorContainer,
                                duration: const Duration(seconds: 2),
                                dismissDirection: DismissDirection.up,
                              ),
                            );
                          } else {
                            final transaction = TransactionDetailsModel(
                              transactionCategoryLabel:
                                  selectedTransactionCategory!.label,
                              transactionCategoryIcon:
                                  selectedTransactionCategory!.icon,
                              transactionSourceLabel:
                                  selectedTransactionSource!.label,
                              transactionSourceIcon:
                                  selectedTransactionSource!.icon,
                              notes: input.notes,
                              amount: input.amount,
                              dateTime: input.dateTime,
                              id: widget.transactionID!,
                            );

                            if (widget.isEditMode == true) {
                              // Await update then refresh history so UI reflects changes
                              context.read<HistoryProvider>().updateTransaction(
                                transactionType,
                                transaction,
                              );
                              await context
                                  .read<HistoryProvider>()
                                  .getTransactions(transactionType);
                            } else {
                              // Await add, then refresh history. Also optimistically add to history list.
                              context
                                  .read<TransactionProvider>()
                                  .addTransaction(transactionType, transaction);
                              context
                                  .read<HistoryProvider>()
                                  .addTransactionToHistory(transaction);
                              await context
                                  .read<HistoryProvider>()
                                  .getTransactions(transactionType);
                            }

                            if (!mounted) return;

                            if (provider.error == null) {
                              if (widget.isEditMode == true) {
                                navigator.pop();
                              } else {
                                navigator.push(
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              }

                              scaffoldMessenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    widget.isEditMode == true
                                        ? "${transactionType.name.capitalize} Updated Successfully"
                                        : "${transactionType.name.capitalize} Added Successfully",
                                    style: ThemeHelper.bodyMedium!.copyWith(
                                      color: ThemeHelper.onSecondary,
                                    ),
                                  ),
                                  backgroundColor: ThemeHelper.secondary,
                                ),
                              );
                            }
                          }
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                provider.isLoading ? null : Icons.save,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                              SizedBox(width: 10),
                              provider.isLoading
                                  ? CircularProgressIndicator()
                                  : Text(
                                      widget.transaction != null
                                          ? 'Update'
                                          : 'Save',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSecondary,
                                          ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddTransactionFAB extends StatefulWidget {
  const AddTransactionFAB({super.key});

  @override
  State<AddTransactionFAB> createState() => _AddTransactionFABState();
}

class _AddTransactionFABState extends State<AddTransactionFAB> {
  final addCategoryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: ThemeHelper.onSurface,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddTransactionPage(
              transactionType: TransactionType.expense,
            ),
          ),
        );
      },
      icon: Icon(Icons.add, color: ThemeHelper.onError),
      label: Text(
        'Add Transaction',
        style: Theme.of(
          context,
        ).textTheme.titleLarge!.copyWith(color: ThemeHelper.onError),
      ),
    );
  }
}
