import 'dart:async';

import 'package:expense_tracker/features/homepage/features/dashboard/domain/entities/analysis/transaction_distribution.dart';
import 'package:expense_tracker/features/homepage/features/history/domain/usecases/get_transaction_usecase.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DashboardProvider extends ChangeNotifier {
  final GetTransactionsUsecase getTransactionsUsecase;

  DashboardProvider({required this.getTransactionsUsecase});

  Future<double> totalOfTransaction(TransactionType transactionType) async {
    final transactions = await getTransactionsUsecase(transactionType);

    final box = await Hive.openBox('analysisOf${transactionType.name}');

    double total = 0;
    for (final transaction in transactions) {
      total += transaction.amount;
    }
    await box.put('total', total);
    return total;
  }

  Future<List> getTransactionRatio(
    TransactionType transactionType,
    TransactionRatioType transactionRatioType,
  ) async {
    final transactions = await getTransactionsUsecase(transactionType);
    String label;
    double amount;
    double total = 0;

    if (transactions.isNotEmpty) {
      total = transactions.fold(
        0,
        (previousValue, element) => previousValue + element.amount,
      );
    }

    if (transactionRatioType == TransactionRatioType.category) {
      List<TransactionCategoryDistribution> data = [];

      for (final transaction in transactions) {
        label = transaction.transactionCategoryLabel;
        amount = transaction.amount;
        double percentage = (amount / total) * 100;

        if (data.any((element) => element.label == label)) {
          final index = data.indexWhere((element) => element.label == label);
          data[index].percentage += percentage;
          data[index].amount += amount;
        } else {
          data.add(
            TransactionCategoryDistribution(
              label: label,
              percentage: percentage,
              amount: amount,
            ),
          );
        }
      }

      return data;
    } else {
      List<TransactionSourceDistribution> data = [];

      for (final transaction in transactions) {
        label = transaction.transactionSourceLabel;
        amount = transaction.amount;
        double percentage = (amount / total) * 100;

        if (data.any((element) => element.label == label)) {
          final index = data.indexWhere((element) => element.label == label);
          data[index].percentage += percentage;
          data[index].amount += amount;
        } else {
          data.add(
            TransactionSourceDistribution(
              label: label,
              percentage: percentage,
              amount: amount,
            ),
          );
        }
      }

      return data;
    }
  }
}
