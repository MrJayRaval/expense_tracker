import '../../config/theme_helper.dart';
import 'models/calc_input_model.dart';
import 'textbox.dart';
import 'package:flutter/material.dart';

class OnScreenKeyBoard extends StatefulWidget {
  final bool? isEditMode;

  final String? calculationDisplay;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final String? notes;
  final ValueChanged<TransactionInput>? onCompleted;

  const OnScreenKeyBoard({
    super.key,
    required this.onCompleted,
    this.isEditMode,
    this.calculationDisplay,
    this.selectedDate,
    this.selectedTime, this.notes,
  });

  @override
  State<OnScreenKeyBoard> createState() => _OnScreenKeyBoardState();
}

class _OnScreenKeyBoardState extends State<OnScreenKeyBoard> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final addNotesTextEditingController = TextEditingController();

  String? calculationDisplay;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();

    if (widget.isEditMode == false) {
      calculationDisplay = '0';
      selectedDate = DateTime.now();
      selectedTime = TimeOfDay.now();
    } else {
      calculationDisplay = widget.calculationDisplay;
      selectedDate = widget.selectedDate;
      selectedTime = widget.selectedTime;
      addNotesTextEditingController.text = widget.notes!;
    }
  }

  void _emitValue() {
    if (calculationDisplay == 'Error') return;

    final dateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    widget.onCompleted!(
      TransactionInput(
        amount: double.tryParse(calculationDisplay!) ?? 0,
        notes: addNotesTextEditingController.text.trim(),
        dateTime: dateTime,
      ),
    );
  }

  void _onCalculatorInput(String value) {
    setState(() {
      if (value == 'C') {
        calculationDisplay = '0';
      } else if (value == 'DEL') {
        if (calculationDisplay!.length > 1) {
          calculationDisplay = calculationDisplay!.substring(
            0,
            calculationDisplay!.length - 1,
          );
        } else {
          calculationDisplay = '0';
        }
      } else if (value == '=') {
        try {
          final result = _evaluateExpression(calculationDisplay!);
          calculationDisplay = result.toString();
        } catch (e) {
          calculationDisplay = 'Error';
        }
      } else {
        if (calculationDisplay == '0' && value != '.') {
          calculationDisplay = value;
        } else {
          calculationDisplay = calculationDisplay! + value;
        }
      }
    });

    _emitValue();
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
      _emitValue();
    }
  }

  Future<void> _selectTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime!,
    );
    if (pickedTime != null) {
      setState(() => selectedTime = pickedTime);
      _emitValue();
    }
  }

  @override
  void dispose() {
    addNotesTextEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Form(
            key: formKey,
            child: CustTextField(
              label: 'Add Notes',
              controller: addNotesTextEditingController,
              onChanged: (_) {
                _emitValue();
              },
              borderWidth: 1,
              maxLines: null,
              minLines: 3,
              textStyle: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: ThemeHelper.outline),
              borderColor: ThemeHelper.outline,
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
                    border: Border.all(color: ThemeHelper.outline),
                    borderRadius: BorderRadius.circular(8),
                    color: ThemeHelper.surface,
                  ),
                  child: Text(
                    calculationDisplay!,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
              SizedBox(width: 10),
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
              Expanded(
                child: Container(
                  // width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    color: ThemeHelper.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _onCalculatorInput('C'),
                      child: Center(
                        child: Text(
                          'Clear All',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: Container(
                  // width: double.minPositive,
                  height: 50,
                  decoration: BoxDecoration(
                    color: ThemeHelper.errorContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _onCalculatorInput('DEL');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.backspace_outlined,
                            color: ThemeHelper.error,
                          ),
                          SizedBox(width: 10),
                          Text('Delete'),
                        ],
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
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: ThemeHelper.outline),
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
                          '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
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
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: ThemeHelper.outline),
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
                          '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),
        ],
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
                ? ThemeHelper.primary
                : isDecimal
                ? Theme.of(context).colorScheme.tertiaryContainer
                : ThemeHelper.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: ThemeHelper.outline, width: 0.5),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: isOperator
                    ? ThemeHelper.onPrimary
                    : ThemeHelper.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
