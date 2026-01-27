import 'package:expense_tracker/features/income/domain/entity/income_details_model.dart';

abstract class HistoryRemoteDataSource {
  Future<List<IncomeDetailsModel>> fetchIncomeHistory();
  Future<void> deleteParticularIncome(String id);
}
