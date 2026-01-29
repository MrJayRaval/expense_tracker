import '../repository/history_repository.dart';
import '../../../income/domain/entity/income_details_model.dart';

class GetIncomesUsecase {

  final HistoryRepository repository;
  
  GetIncomesUsecase(this.repository);
/// Retrieves all the income history data from the local storage and the cloud.
///
/// This function returns a Future that completes when the income history data is retrieved.
///
/// The income history data is retrieved from the local storage and the cloud.
///
/// The function takes no parameters and returns a Future that completes with no value.
///
/// The function will throw an exception if the income history data cannot be retrieved.
///
/// The function will also notify the listeners of the provider when the income history data is retrieved.
  Future<List<IncomeDetailsModel>> call() async {
    return repository.getIncome();
  }
}