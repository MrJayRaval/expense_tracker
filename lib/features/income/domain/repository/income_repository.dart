import 'package:expense_tracker/features/income/domain/entity/income_details_model.dart';

abstract class IncomeRepository {
  Future<void> addIncome(IncomeDetailsModel income);
}
