import 'package:expense_tracker/features/income/domain/entity/income_details_model.dart';
import 'package:expense_tracker/features/income/domain/repository/income_repository.dart';

class AddIncomeUsecase {
  final IncomeRepository repository;

  AddIncomeUsecase({required this.repository});

  Future<void> call(IncomeDetailsModel income) async {
    await repository.addIncome(income);
  }
}
