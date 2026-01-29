import '../../domain/usecases/delete_particular_income_usecase.dart';
import '../../domain/usecases/get_incomes_usecase.dart';
import '../../domain/usecases/group_by_date_usecase.dart';
import '../../domain/usecases/update_income_usecase.dart';
import '../../../income/domain/entity/income_details_model.dart';
import 'package:flutter/material.dart';

class HistoryProvider extends ChangeNotifier {
  final GetIncomesUsecase getIncomesUsecase;
  final DeleteParticularIncomeUsecase deleteParticularIncomeUsecase;
  final UpdateIncomeUsecase updateIncomeUsecase;
  final GroupByDateUseCase groupByDateUseCase;

  HistoryProvider({
    required this.getIncomesUsecase,
    required this.deleteParticularIncomeUsecase,
    required this.updateIncomeUsecase, required this.groupByDateUseCase,
  });

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
      debugPrint(
        'HistoryProvider: fetched ${incomes.length} incomes from usecase',
      );
      _incomes
        ..clear()
        ..addAll(incomes);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      debugPrint('HistoryProvider.getIncomes error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteParticularIncome(String id) async {
    _incomes.removeWhere((element) => element.id == id);
    notifyListeners();
    error = null;

    try {
      await deleteParticularIncomeUsecase(id);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateIncome(IncomeDetailsModel income) async {
    // Update the in-memory list so UI updates immediately
    final index = _incomes.indexWhere((element) => element.id == income.id);
    if (index != -1) {
      _incomes[index] = income;
      notifyListeners();
    } else {
      // If not found, refresh from source
      try {
        final incomes = await getIncomesUsecase();
        _incomes
          ..clear()
          ..addAll(incomes);
        notifyListeners();
      } catch (e) {
        // ignore
      }
    }
    error = null;
    notifyListeners();
    try {
      await updateIncomeUsecase(income);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      debugPrint('HistoryProvider.updateIncome error: $e');
      isLoading = false;
      notifyListeners();
    }
  }

  Map<DateTime, List<IncomeDetailsModel>> groupByDate(List<IncomeDetailsModel> incomes) {
    return groupByDateUseCase(incomes);
  }

  void addIncomeToHistory(IncomeDetailsModel income) {
    _incomes.insert(0, income);
    notifyListeners();
  }
}
