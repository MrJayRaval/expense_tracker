import 'package:expense_tracker/ui/models/enum.dart';
import 'package:expense_tracker/ui/models/trasaction_details_model.dart';

abstract class HistoryLocalDataSource {
  Future<void> cacheTransactionHistory(TransactionType transactionType, List<TransactionDetailsModel> transactions);
  Future<List<TransactionDetailsModel>> getTransaction(TransactionType transactionType);
  Future<void> deleteParticularTransaction(TransactionType transactionType, String id);
  Future<void> deleteAllTransaction(TransactionType transactionType);
  Future<void> updateTransaction(TransactionType transactionType, TransactionDetailsModel transaction);
  Map<DateTime, List<TransactionDetailsModel>> groupByDate(
    List<TransactionDetailsModel> Transaction,
  );
}
