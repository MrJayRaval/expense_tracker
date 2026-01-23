import 'package:expense_tracker/config/theme_helper.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late bool isExpense;

  @override
  void initState() {
    super.initState();
    isExpense = true;
  }

  @override
  Widget build(BuildContext context) {
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
                      isExpense = false;
                    });
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: (isExpense == true)
                            ? BorderSide.none
                            : BorderSide(width: 3, color: ThemeHelper.primary)
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
                      isExpense = true;
                    });
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: (isExpense == false)
                            ? BorderSide.none
                            : BorderSide(width: 3, color: ThemeHelper.primary)
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
        ],
      ),
    );
  }
}
