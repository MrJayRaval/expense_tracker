import 'package:expense_tracker/ui/models/enum.dart';

import '../repository/history_repository.dart';

class DeleteParticularTransactionUsecase {
  final HistoryRepository repository;
  DeleteParticularTransactionUsecase(this.repository);
  Future<void> call(TransactionType transactionType, String id) async  => await repository.deleteParticularTransaction(transactionType,id);
}