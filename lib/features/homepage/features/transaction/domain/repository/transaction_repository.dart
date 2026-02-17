import 'package:expense_tracker/ui/models/enum.dart';

import '../../../../../../ui/models/trasaction_details_model.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(
    TransactionType transactionType,
    TransactionDetailsModel transaction,
  );
}
