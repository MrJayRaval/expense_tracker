import 'package:expense_tracker/ui/models/enum.dart';

import '../repository/history_repository.dart';
import '../../../../../../ui/models/trasaction_details_model.dart';

class UpdateTransactionUsecase {
  final HistoryRepository repository;

  UpdateTransactionUsecase({required this.repository});

  Future<void> call(TransactionType transactionType, TransactionDetailsModel income) async {
    await repository.updateTransaction(transactionType, income);
  }
}
