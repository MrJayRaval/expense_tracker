import 'dart:async';

import 'package:expense_tracker/features/homepage/features/history/domain/usecases/get_transaction_usecase.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  final GetTransactionsUsecase getTransactionsUsecase;

  DashboardProvider({required this.getTransactionsUsecase});

  Future<double> totalOfTransaction(TransactionType transactionType) async {
    final transactions = await getTransactionsUsecase(transactionType);

    double total = 0;
    for (final transaction in transactions) {
      total += transaction.amount;
    }
    return total;
  }
}