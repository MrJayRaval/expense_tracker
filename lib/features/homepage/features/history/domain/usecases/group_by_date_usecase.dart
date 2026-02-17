import '../repository/history_repository.dart';
import '../../../../../../ui/models/trasaction_details_model.dart';

class GroupByDateUseCase {
  final HistoryRepository repository;

  GroupByDateUseCase({required this.repository});

  Map<DateTime, List<TransactionDetailsModel>> call(
    List<TransactionDetailsModel> income,
  ) {
    return repository.groupByDate(income);
  }
}
