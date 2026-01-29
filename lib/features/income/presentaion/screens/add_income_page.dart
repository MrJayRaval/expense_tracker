import '../../../../config/theme_helper.dart';
import '../../../history/presenation/providers/history_provider.dart';
import '../../../homepage/presentation/screens/homepage.dart';
import '../../domain/entity/income_details_model.dart';
import '../../domain/entity/income_source_model.dart';
import '../../domain/entity/income_type_model.dart';
import '../provider/income_provider.dart';
import 'income_source.dart';
import 'income_type.dart';
import '../../../../ui/components/button.dart';
import '../../../../ui/components/models/calc_input_model.dart';
import '../../../../ui/components/onscreen_keyboard.dart';
import '../../../../ui/components/raise_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddIncomePage extends StatefulWidget {
  final IncomeDetailsModel? income;
  final bool? isEditMode;
  final String? incomeID;
  const AddIncomePage({
    super.key,
    this.income,
    this.isEditMode = false,
    this.incomeID = "",
  });

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TransactionInput input;

  int? selectedIncomeIndex;
  IncomeType? selectedIncomeType;
  IncomeSource? selectedIncomeSource;

  @override
  void initState() {
    super.initState();

    if (widget.income != null) {
      final i = widget.income!;

      input = TransactionInput(
        notes: i.notes,
        amount: i.amount,
        dateTime: i.dateTime,
      );
      selectedIncomeType = IncomeType(
        label: i.incomeTypeLabel,
        icon: i.incomeTypeIcon,
      );
      selectedIncomeSource = IncomeSource(
        label: i.incomeSourceLabel,
        icon: i.incomeSourceIcon,
      );
    } else {
      input = TransactionInput(notes: '', amount: 0, dateTime: DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IncomeProvider>();
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
                  Text(
                    widget.income != null ? 'Edit Income' : 'Add Income',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: ThemeHelper.onSurface,
                    ),
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustOutlinedButton(
                          label: selectedIncomeType?.label ?? 'Income Type',
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
                                      Text("Choose Income Type"),
                                    ],
                                  ),

                                  content: SizedBox(
                                    width: double.maxFinite,
                                    height: 300,
                                    child: IncomeTypeWidget(
                                      onItemSelected: (value) {
                                        setState(() {
                                          selectedIncomeType = IncomeType(
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
                          label: selectedIncomeSource?.label ?? 'Income Source',
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
                                      Text("Choose Income Type"),
                                    ],
                                  ),

                                  content: SizedBox(
                                    width: double.maxFinite,
                                    height: 300,
                                    child: IncomeSourceWidget(
                                      onItemSelected: (value) {
                                        setState(() {
                                          selectedIncomeSource = IncomeSource(
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

                          if ((selectedIncomeType?.label ?? '').isEmpty) {
                            errors.add('Select Income Type');
                          }

                          if ((selectedIncomeSource?.label ?? '').isEmpty) {
                            errors.add('Select Income Source');
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
                            final income = IncomeDetailsModel(
                              incomeTypeLabel: selectedIncomeType!.label,
                              incomeTypeIcon: selectedIncomeType!.icon,
                              incomeSourceLabel: selectedIncomeSource!.label,
                              incomeSourceIcon: selectedIncomeSource!.icon,
                              notes: input.notes,
                              amount: input.amount,
                              dateTime: input.dateTime,
                              id: widget.incomeID!,
                            );

                            if (widget.isEditMode == true) {
                              // Await update then refresh history so UI reflects changes
                              context.read<HistoryProvider>().updateIncome(
                                income,
                              );
                              await context
                                  .read<HistoryProvider>()
                                  .getIncomes();
                            } else {
                              // Await add, then refresh history. Also optimistically add to history list.
                              context.read<IncomeProvider>().addIncome(income);
                              context
                                  .read<HistoryProvider>()
                                  .addIncomeToHistory(income);
                              await context
                                  .read<HistoryProvider>()
                                  .getIncomes();
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
                                        ? "Income Updated Successfully"
                                        : "Income Added Successfully",
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
                                      widget.income != null ? 'Update' : 'Save',
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
