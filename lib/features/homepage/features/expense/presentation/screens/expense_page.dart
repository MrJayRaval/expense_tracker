import 'package:expense_tracker/features/homepage/features/category/presenation/providers/category_provider.dart';
import 'package:expense_tracker/ui/components/category_list_widget.dart';
import 'package:expense_tracker/ui/components/segmented_toggle.dart';
import 'package:flutter/material.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  // 0 = Categories, 1 = Source
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SegmentedToggle<int>(
            options: const {0: 'Categories', 1: 'Source'},
            selectedValue: _selectedIndex,
            onValueChanged: (value) {
              setState(() {
                _selectedIndex = value;
              });
            },
          ),
          Expanded(
            child: _selectedIndex == 0
                ? const CategoryListWidget<ExpenseCategoryProvider>(
                    title: 'Categories',
                  )
                : const CategoryListWidget<SourceProvider>(title: 'Assets'),
          ),
        ],
      ),
    );
  }
}
