import '../entity/income_details_model.dart';

abstract class IncomeRepository {
  Future<void> addIncome(IncomeDetailsModel income);
}
