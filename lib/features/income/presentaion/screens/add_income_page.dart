import 'package:expense_tracker/features/income/domain/entity/income_source_model%20copy.dart';
import 'package:expense_tracker/features/income/domain/entity/income_type_model.dart';
import 'package:expense_tracker/features/income/presentaion/screens/income_source.dart';
import 'package:expense_tracker/features/income/presentaion/screens/income_type.dart';
import 'package:expense_tracker/ui/components/button.dart';
import 'package:expense_tracker/ui/components/onscreen_keyboard.dart';
import 'package:flutter/material.dart';

class AddIncomePage extends StatefulWidget {
  const AddIncomePage({super.key});

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final addNotesTextEditingController = TextEditingController();

  String calculationDisplay = '0';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  IncomeType? selectedIncomeType;
  IncomeSource? selectedIncomeSource;

  void _onCalculatorInput(String value) {
    setState(() {
      if (value == 'C') {
        calculationDisplay = '0';
      } else if (value == 'DEL') {
        if (calculationDisplay.length > 1) {
          calculationDisplay = calculationDisplay.substring(
            0,
            calculationDisplay.length - 1,
          );
        } else {
          calculationDisplay = '0';
        }
      } else if (value == '=') {
        try {
          final result = _evaluateExpression(calculationDisplay);
          calculationDisplay = result.toString();
        } catch (e) {
          calculationDisplay = 'Error';
        }
      } else {
        if (calculationDisplay == '0' && value != '.') {
          calculationDisplay = value;
        } else {
          calculationDisplay += value;
        }
      }
    });
  }

  double _evaluateExpression(String expression) {
    // Simple evaluation: replace operators and calculate
    expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
    // Using a simple evaluation (in production, use a proper expression evaluator)
    return double.parse(
      expression.split(RegExp(r'[+\-*/]')).fold(0.0, (prev, element) {
        return prev + double.parse(element.isEmpty ? '0' : element);
      }).toString(),
    );
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() => selectedDate = pickedDate);
    }
  }

  Future<void> _selectTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null) {
      setState(() => selectedTime = pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Add Income',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustOutlinedButton(
                          label: 'Income Type',
                          textStyle: Theme.of(context).textTheme.bodyMedium!,
                          borderRadius: 6,
                          borderWidth: 1.5,
                          borderColor: Theme.of(context).colorScheme.outline,
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
                          label: 'Income Source',
                          textStyle: Theme.of(context).textTheme.bodyMedium!,
                          borderRadius: 6,
                          borderWidth: 1.5,
                          borderColor: Theme.of(context).colorScheme.outline,
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

                  OnScreenKeyBoard()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _calcButton(String label) {
    final isOperator = ['+', '-', '×', '÷', '='].contains(label);
    final isDecimal = label == '.';

    return Material(
      color: const Color.fromARGB(0, 0, 0, 0),
      child: InkWell(
        onTap: () => _onCalculatorInput(label),
        borderRadius: BorderRadius.circular(6),
        child: Container(
          decoration: BoxDecoration(
            color: isOperator
                ? Theme.of(context).colorScheme.primary
                : isDecimal
                ? Theme.of(context).colorScheme.tertiaryContainer
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 0.5,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: isOperator
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
