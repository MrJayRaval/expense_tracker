import '../../data/repository/history_repository_impl.dart';
import '../../../../../../ui/models/trasaction_details_model.dart';

class GroupByDateUseCase {
  final HistoryRepositoryImpl repository;

  GroupByDateUseCase({required this.repository});

  Map<DateTime, List<TransactionDetailsModel>> call(
    List<TransactionDetailsModel> income,
  ) {
    return repository.groupByDate(income);
  }
}
