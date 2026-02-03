import 'package:expense_tracker/ui/models/enum.dart';

import '../../../../../../ui/models/trasaction_details_model.dart';
import '../../domain/usecases/add_income_usecase.dart';
import 'package:flutter/material.dart';

class TransactionProvider extends ChangeNotifier {
  final AddIncomeUsecase addIncomeUsecase;

  TransactionProvider({required this.addIncomeUsecase});

  bool isLoading = false;
  String? error;

  void clearError() {
    error = null;
    notifyListeners();
  }

  Future<bool> addTransaction(
    TransactionType transactionType,
    TransactionDetailsModel income,
  ) async {
    isLoading = true;
    notifyListeners();
    bool success = false;

    try {
      await addIncomeUsecase(transactionType, income);
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
