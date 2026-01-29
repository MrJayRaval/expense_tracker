import '../entity/income_details_model.dart';
import '../repository/income_repository.dart';

class AddIncomeUsecase {
  final IncomeRepository repository;

  AddIncomeUsecase({required this.repository});

  Future<void> call(IncomeDetailsModel income) async {
    await repository.addIncome(income);
  }
}
