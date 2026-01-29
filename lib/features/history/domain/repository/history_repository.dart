import '../../../income/domain/entity/income_details_model.dart';

abstract class HistoryRepository {
  Future<List<IncomeDetailsModel>> getIncome();
  Future<void> deleteParticularIncome(String id);
  Future<void> updateIncome(IncomeDetailsModel income);
  Map<DateTime, List<IncomeDetailsModel>> groupByDate(
    List<IncomeDetailsModel> income,
  );
}
