import 'package:expense_tracker/ui/models/enum.dart';

import '../../domain/datasource/data_remote_source.dart';
import '../../../../../../ui/models/trasaction_details_model.dart';
import '../../domain/repository/income_repository.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  final TransactionDataSource remote;

  IncomeRepositoryImpl({required this.remote});
  @override
  Future<void> addTransaction(TransactionType transactionType,TransactionDetailsModel income) async {
    await remote.addTransactions(transactionType,income);
  }
}
