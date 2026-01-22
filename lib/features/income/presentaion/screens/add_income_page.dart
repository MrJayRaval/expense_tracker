import 'package:expense_tracker/config/theme_helper.dart';
import 'package:expense_tracker/features/homepage/presentation/screens/homepage.dart';
import 'package:expense_tracker/features/income/domain/entity/income_details_model.dart';
import 'package:expense_tracker/features/income/domain/entity/income_source_model.dart';
import 'package:expense_tracker/features/income/domain/entity/income_type_model.dart';
import 'package:expense_tracker/features/income/presentaion/provider/add_income_provider.dart';
import 'package:expense_tracker/features/income/presentaion/screens/income_source.dart';
import 'package:expense_tracker/features/income/presentaion/screens/income_type.dart';
import 'package:expense_tracker/ui/components/button.dart';
import 'package:expense_tracker/ui/components/models/calc_input_model.dart';
import 'package:expense_tracker/ui/components/onscreen_keyboard.dart';
import 'package:expense_tracker/ui/components/raise_error.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AddIncomePage extends StatefulWidget {
  const AddIncomePage({super.key});

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final addNotesTextEditingController = TextEditingController();
  late TransactionInput input;

  int? selectedIncomeIndex;
  IncomeType? selectedIncomeType;
  IncomeSource? selectedIncomeSource;

  @override
  void initState() {
    super.initState();
    input = TransactionInput(
    notes: '',
    amount: 0,
    dateTime: DateTime.now(),
  );

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
                    'Add Income',
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
                        onTap: () {
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
                            );
                            context.read<IncomeProvider>().addIncome(income);

                            if (provider.error == null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Income Added Successfully",
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
                                      'Save',
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
