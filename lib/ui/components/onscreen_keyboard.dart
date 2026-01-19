import 'package:expense_tracker/ui/components/textbox.dart';
import 'package:flutter/material.dart';

class OnScreenKeyBoard extends StatefulWidget {
  const OnScreenKeyBoard({super.key});

  @override
  State<OnScreenKeyBoard> createState() => _OnScreenKeyBoardState();
}

class _OnScreenKeyBoardState extends State<OnScreenKeyBoard> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final addNotesTextEditingController = TextEditingController();

  String calculationDisplay = '0';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

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
    return Column(
      children: [
        Form(
                    key: formKey,
                    child: CustTextField(
                      label: 'Add Notes',
                      controller: addNotesTextEditingController,
                      borderWidth: 1,
                      maxLines: null,
                      minLines: 3,
                      textStyle: Theme.of(context).textTheme.bodyMedium!
                          .copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                      borderColor: Theme.of(context).colorScheme.outline,
                    ),
                  ),

                  SizedBox(height: 20),

                  // Calculator Display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          width: 48,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: Text(
                            calculationDisplay,
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),

                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _onCalculatorInput('DEL'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.backspace_outlined,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  // Calculator Grid
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: [
                      _calcButton('7'),
                      _calcButton('8'),
                      _calcButton('9'),
                      _calcButton('÷'),
                      _calcButton('4'),
                      _calcButton('5'),
                      _calcButton('6'),
                      _calcButton('×'),
                      _calcButton('1'),
                      _calcButton('2'),
                      _calcButton('3'),
                      _calcButton('-'),
                      _calcButton('0'),
                      _calcButton('.'),
                      _calcButton('='),
                      _calcButton('+'),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Clear Button
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _onCalculatorInput('C'),
                            child: Center(
                              child: Text(
                                'C',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 10),

                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              // onTap: () {
                              //   if (
                              //       calculationDisplay != '0' &&
                              //       calculationDisplay != 'Error') {
                              //     // Create IncomeDetails object
                              //     final incomeDetails = IncomeDetailsModel(
                              //       amount: double.parse(calculationDisplay),
                              //       notes: addNotesTextEditingController.text,
                              //       date: selectedDate,
                              //       time: selectedTime,
                              //       incomeSourceLabel:
                              //           selectedIncomeSource!.label,
                              //       incomeSourceIcon:
                              //           selectedIncomeSource!.icon,
                              //     );
                              //     print(incomeDetails.amount);
                              //     print(incomeDetails.date);
                              //     print(incomeDetails.dateTime);
                              //     print(incomeDetails.incomeSourceIcon);
                              //     print(incomeDetails.incomeSourceLabel);
                              //     print(incomeDetails.incomeTypeIcon);
                              //     print(incomeDetails.incomeTypeLabel);
                              //     print(incomeDetails.notes);
                              //     print(incomeDetails.time);
                              //   } else {
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //       SnackBar(
                              //         content: Text('Please fill all fields'),
                              //       ),
                              //     );
                              //   }
                              // },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.save,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondary,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
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
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Date and Time Selection
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _selectDate,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: _selectTime,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Time',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
      ],
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

