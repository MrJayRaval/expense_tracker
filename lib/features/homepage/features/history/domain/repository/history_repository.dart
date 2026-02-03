import 'package:expense_tracker/ui/models/enum.dart';

import '../../../../../../ui/models/trasaction_details_model.dart';

abstract class HistoryRepository {
  Future<List<TransactionDetailsModel>> getTransaction(TransactionType transactionType);
  Future<void> deleteParticularTransaction(TransactionType transactionType, String id);
  Future<void> updateTransaction(TransactionType transactionType, TransactionDetailsModel transacion);
  Map<DateTime, List<TransactionDetailsModel>> groupByDate(
    List<TransactionDetailsModel> transactions,
  );
}
