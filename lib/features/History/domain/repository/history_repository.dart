import 'package:expense_tracker/features/income/domain/entity/income_details_model.dart';

abstract class HistoryRepository {
  Future<List<IncomeDetailsModel>> getIncome();
  Future<void> deleteParticularIncome(String id);
}
