import 'package:expense_tracker/features/homepage/features/transaction/domain/repository/transaction_repository.dart';
import 'package:expense_tracker/ui/models/enum.dart';

import '../../domain/datasource/data_remote_source.dart';
import '../../../../../../ui/models/trasaction_details_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionDataSource remote;

  TransactionRepositoryImpl({required this.remote});
  @override
  Future<void> addTransaction(
    TransactionType transactionType,
    TransactionDetailsModel transaction,
  ) async {
    await remote.addTransactions(transactionType, transaction);
  }
}
