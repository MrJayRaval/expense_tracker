import 'package:expense_tracker/ui/models/enum.dart';

import '../../../../../../ui/models/trasaction_details_model.dart';

abstract class TransactionDataSource {
  Future<void> addTransactions(TransactionType transactionType ,TransactionDetailsModel income);
}
