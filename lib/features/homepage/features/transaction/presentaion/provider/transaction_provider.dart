import 'package:expense_tracker/features/homepage/features/transaction/domain/usecases/add_income_usecase.dart';
import 'package:expense_tracker/ui/models/enum.dart';

import '../../../../../../ui/models/trasaction_details_model.dart';
import 'package:flutter/material.dart';

class TransactionProvider extends ChangeNotifier {
  final AddTransactionUsecase addTransactionUsecase;

  TransactionProvider({required this.addTransactionUsecase});

  bool isLoading = false;
  String? error;

  void clearError() {
    error = null;
    notifyListeners();
  }

  Future<bool> addTransaction(
    TransactionType transactionType,
    TransactionDetailsModel transaction,
  ) async {
    isLoading = true;
    notifyListeners();
    bool success = false;

    try {
      addTransactionUsecase(transactionType, transaction);
      success = true;
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return success;
  }
}
