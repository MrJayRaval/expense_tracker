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

import '../../../../../../ui/models/calc_input_model.dart';
import '../../../../../../ui/components/onscreen_keyboard.dart';
import '../../../../../../ui/components/raise_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                  // Toggle Button
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: ThemeHelper.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        _buildTypeToggle(
                          context,
                          label: 'Expense',
                          type: TransactionType.expense,
                          isSelected:
                              transactionType == TransactionType.expense,
                        ),
                        _buildTypeToggle(
                          context,
                          label: 'Income',
                          type: TransactionType.income,
                          isSelected: transactionType == TransactionType.income,
                        ),
                      ],
                    ),
                  ),

                  // Selection Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildSelectionCard(
                          context,
                          title: "Category",
                          label: selectedTransactionCategory?.label,
                          iconPath: selectedTransactionCategory?.icon,
                          onTap: () {
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
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSelectionCard(
                          context,
                          title: "Source",
                          label: selectedTransactionSource?.label,
                          iconPath: selectedTransactionSource?.icon,
                          onTap: () {
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

                  SizedBox(height: 25),

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
                                  .loadTransaction();
                            } else {
                              // Await add, then refresh history. Also optimistically add to history list.
                              context
                                  .read<TransactionProvider>()
                                  .addTransaction(transactionType, transaction);
                              context
                                  .read<HistoryProvider>()
                                  .addTransactionToHistory(
                                    transactionType,
                                    transaction,
                                  );

                              await context
                                  .read<HistoryProvider>()
                                  .loadTransaction();
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

  Widget _buildTypeToggle(
    BuildContext context, {
    required String label,
    required TransactionType type,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!isSelected) {
            setState(() {
              transactionType = type;
              // Reset category and source when changing transaction type
              selectedTransactionCategory = null;
              selectedTransactionSource = null;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? ThemeHelper.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: ThemeHelper.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isSelected
                    ? ThemeHelper.onPrimary
                    : ThemeHelper.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionCard(
    BuildContext context, {
    required String title,
    required String? label,
    required String? iconPath,
    required VoidCallback onTap,
  }) {
    final bool hasSelection = label != null && label.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeHelper.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hasSelection ? ThemeHelper.primary : ThemeHelper.outline,
            width: hasSelection ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasSelection && iconPath != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeHelper.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  iconPath,
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    ThemeHelper.primary,
                    BlendMode.srcIn,
                  ),
                ),
              )
            else
              Icon(
                title == "Category"
                    ? Icons.category_outlined
                    : Icons.account_balance_wallet_outlined,
                size: 32,
                color: ThemeHelper.onSurfaceVariant.withOpacity(0.5),
              ),

            const SizedBox(height: 12),

            Text(
              hasSelection ? label : "Select $title",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: hasSelection
                    ? ThemeHelper.onSurface
                    : ThemeHelper.onSurfaceVariant,
                fontWeight: hasSelection ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ],
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
        ).textTheme.titleMedium!.copyWith(color: ThemeHelper.onError),
      ),
    );
  }
}
