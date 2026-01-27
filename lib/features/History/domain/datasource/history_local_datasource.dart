import 'package:expense_tracker/features/income/domain/entity/income_details_model.dart';

abstract class HistoryLocalDataSource {
  Future<void> cacheIncomeHistory(List<IncomeDetailsModel> income);
  Future<List<IncomeDetailsModel>> getIncome();
  Future<void> deleteParticularIncome(String id);
  Future<void> deleteAllIncome();
}
