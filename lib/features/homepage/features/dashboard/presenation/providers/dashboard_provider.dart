import 'package:expense_tracker/features/homepage/features/dashboard/domain/entities/analysis/transaction_distribution.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import 'package:expense_tracker/ui/models/trasaction_details_model.dart';
import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  List<TransactionDetailsModel> _allIncome = [];
  List<TransactionDetailsModel> _allExpense = [];
  DateTime _selectedMonth = DateTime.now();

  DateTime get selectedMonth => _selectedMonth;

  void updateMonth(DateTime month) {
    _selectedMonth = month;
    notifyListeners();
  }

  bool get hasAnyTransaction => _allIncome.isNotEmpty || _allExpense.isNotEmpty;

  void updateData(
    List<TransactionDetailsModel> income,
    List<TransactionDetailsModel> expense,
  ) {
    _allIncome = income;
    _allExpense = expense;
    notifyListeners();
  }

  List<TransactionDetailsModel> get _income {
    return _allIncome.where((element) {
      return element.dateTime.year == _selectedMonth.year &&
          element.dateTime.month == _selectedMonth.month;
    }).toList();
  }

  List<TransactionDetailsModel> get _expense {
    return _allExpense.where((element) {
      return element.dateTime.year == _selectedMonth.year &&
          element.dateTime.month == _selectedMonth.month;
    }).toList();
  }

  // Getters use the filtered lists
  double get incomeTotal => _income.fold(0.0, (p, e) => p + e.amount);
  double get expenseTotal => _expense.fold(0.0, (p, e) => p + e.amount);

  List<TransactionCategoryDistribution> get incomeDistribution => _calculate(
    TransactionRatioType.category,
    _income,
  ).cast<TransactionCategoryDistribution>();

  List<TransactionCategoryDistribution> get expenseDistribution => _calculate(
    TransactionRatioType.category,
    _expense,
  ).cast<TransactionCategoryDistribution>();

  List<TransactionSourceDistribution> get incomeSourceDistribution =>
      _calculate(
        TransactionRatioType.source,
        _income,
      ).cast<TransactionSourceDistribution>();

  List<TransactionSourceDistribution> get expenseSourceDistribution =>
      _calculate(
        TransactionRatioType.source,
        _expense,
      ).cast<TransactionSourceDistribution>();

  List _calculate(
    TransactionRatioType type,
    List<TransactionDetailsModel> transactions,
  ) {
    if (transactions.isEmpty) return [];

    final double total = transactions.fold(0, (p, e) => p + e.amount);
    final bool isCategory = type == TransactionRatioType.category;

    if (total == 0) return [];

    final Map<String, dynamic> grouped = {};

    for (final tx in transactions) {
      final String label = isCategory
          ? tx.transactionCategoryLabel
          : tx.transactionSourceLabel;
      final double amount = tx.amount;
      final double percentage = (amount / total) * 100;

      if (grouped.containsKey(label)) {
        grouped[label].amount += amount;
        grouped[label].percentage += percentage;
      } else {
        grouped[label] = isCategory
            ? TransactionCategoryDistribution(
                label: label,
                amount: amount,
                percentage: percentage,
              )
            : TransactionSourceDistribution(
                label: label,
                amount: amount,
                percentage: percentage,
              );
      }
    }
    return grouped.values.toList();
  }
}
