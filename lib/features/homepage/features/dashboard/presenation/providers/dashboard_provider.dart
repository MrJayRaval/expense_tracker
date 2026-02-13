import 'package:expense_tracker/features/homepage/features/dashboard/domain/entities/analysis/transaction_distribution.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import 'package:expense_tracker/ui/models/trasaction_details_model.dart';
import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  List<TransactionDetailsModel> _income = [];
  List<TransactionDetailsModel> _expense = [];

  // 1. Sync data from ProxyProvider
  void updateData(List<TransactionDetailsModel> income, List<TransactionDetailsModel> expense) {
    _income = income;
    _expense = expense;
    notifyListeners();
  }

  // 2. Simple Synchronous Getters
  double get incomeTotal => _income.fold(0.0, (p, e) => p + e.amount);
  double get expenseTotal => _expense.fold(0.0, (p, e) => p + e.amount);

  // Getters that return actual Lists, not Futures
  List<TransactionCategoryDistribution> get incomeDistribution => 
      _calculate(TransactionRatioType.category, _income).cast<TransactionCategoryDistribution>();

  List<TransactionCategoryDistribution> get expenseDistribution => 
      _calculate(TransactionRatioType.category, _expense).cast<TransactionCategoryDistribution>();

  List<TransactionSourceDistribution> get incomeSourceDistribution => 
      _calculate(TransactionRatioType.source, _income).cast<TransactionSourceDistribution>();

  List<TransactionSourceDistribution> get expenseSourceDistribution => 
      _calculate(TransactionRatioType.source, _expense).cast<TransactionSourceDistribution>();

  // 3. Synchronous Calculation Method
  List _calculate(TransactionRatioType type, List<TransactionDetailsModel> transactions) {
    if (transactions.isEmpty) return [];

    final double total = transactions.fold(0, (p, e) => p + e.amount);
    final bool isCategory = type == TransactionRatioType.category;
    
    // Using a Map to group data instantly
    final Map<String, dynamic> grouped = {};

    for (final tx in transactions) {
      final String label = isCategory ? tx.transactionCategoryLabel : tx.transactionSourceLabel;
      final double amount = tx.amount;
      final double percentage = (amount / total) * 100;

      if (grouped.containsKey(label)) {
        grouped[label].amount += amount;
        grouped[label].percentage += percentage;
      } else {
        grouped[label] = isCategory 
          ? TransactionCategoryDistribution(label: label, amount: amount, percentage: percentage)
          : TransactionSourceDistribution(label: label, amount: amount, percentage: percentage);
      }
    }
    return grouped.values.toList();
  }
}