import 'package:expense_tracker/features/History/domain/usecases/delete_particular_income_usecase.dart';
import 'package:expense_tracker/features/History/domain/usecases/get_incomes_usecase.dart';
import 'package:expense_tracker/features/income/domain/entity/income_details_model.dart';
import 'package:flutter/material.dart';

class HistoryProvider extends ChangeNotifier {
  final GetIncomesUsecase getIncomesUsecase;
  final DeleteParticularIncomeUsecase deleteParticularIncomeUsecase;

  HistoryProvider({required this.getIncomesUsecase, required this.deleteParticularIncomeUsecase});

  bool isLoading = false;
  String? error;
  final List<IncomeDetailsModel> _incomes = [];

  List<IncomeDetailsModel> get incomes => _incomes;

  Future<void> getIncomes() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final incomes = await getIncomesUsecase();
      print('HistoryProvider: fetched ${incomes.length} incomes from usecase');
      _incomes
        ..clear()
        ..addAll(incomes);
      isLoading = false;
      notifyListeners();
    } catch (e, st) {
      error = e.toString();
      print('HistoryProvider.getIncomes error: $e');
      print(st);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteParticularIncome(String id) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await deleteParticularIncomeUsecase(id);
      isLoading = false;

      _incomes.removeWhere((element) => element.id == id);
      notifyListeners();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void addIncomeToHistory(IncomeDetailsModel income) {
    _incomes.insert(0,income);
    notifyListeners();
  }
}
