import 'package:expense_tracker/features/income/domain/entity/income_details_model.dart';
import 'package:expense_tracker/features/income/domain/usecases/add_income_usecase.dart';
import 'package:flutter/material.dart';

class IncomeProvider extends ChangeNotifier {
  final AddIncomeUsecase addIncomeUsecase;

  IncomeProvider({required this.addIncomeUsecase});

  bool isLoading = false;
  String? error;

  void clearError() {
    error = null;
    notifyListeners();
  }

  Future<bool> addIncome(IncomeDetailsModel income) async {
    isLoading = true;
    notifyListeners();
    bool success = false;

    try {
      await addIncomeUsecase.addIncome(income);
      success = true;
      error = null;
    } catch (e) {
      error = e.toString();
      success = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return success;
  }
}
