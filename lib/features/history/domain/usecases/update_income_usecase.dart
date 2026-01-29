import '../repository/history_repository.dart';
import '../../../income/domain/entity/income_details_model.dart';

class UpdateIncomeUsecase {
  final HistoryRepository repository;

  UpdateIncomeUsecase({required this.repository});

  Future<void> call(IncomeDetailsModel income) async {
    await repository.updateIncome(income);
  }
}