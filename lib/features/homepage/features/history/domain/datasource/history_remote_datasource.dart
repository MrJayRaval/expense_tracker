import 'package:expense_tracker/ui/models/enum.dart';

import '../../../../../../ui/models/trasaction_details_model.dart';

abstract class HistoryRemoteDataSource {
  Future<List<TransactionDetailsModel>> fetchTransactionHistory(TransactionType transactionType, );
  Future<void> deleteParticularTransaction(TransactionType transactionType, String id);
  Future<void> updateTransaction(TransactionType transactionType, TransactionDetailsModel income);
}
