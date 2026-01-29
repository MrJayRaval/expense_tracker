import '../entity/income_details_model.dart';

abstract class IncomeDataSource {
  Future<void> addIncome(IncomeDetailsModel income);
}
