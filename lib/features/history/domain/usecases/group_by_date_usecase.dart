import '../../data/repository/history_repository_impl.dart';
import '../../../income/domain/entity/income_details_model.dart';

class GroupByDateUseCase {
  final HistoryRepositoryImpl repository;

  GroupByDateUseCase({required this.repository});

  Map<DateTime, List<IncomeDetailsModel>> call (List<IncomeDetailsModel> income){
    return repository.groupByDate(income);
  }

}
