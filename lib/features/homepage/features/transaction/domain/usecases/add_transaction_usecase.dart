import 'package:expense_tracker/features/homepage/features/transaction/domain/repository/transaction_repository.dart';
import 'package:expense_tracker/ui/models/enum.dart';

import '../../../../../../ui/models/trasaction_details_model.dart';

class AddTransactionUsecase {
  final TransactionRepository repository;

  AddTransactionUsecase({required this.repository});

  Future<void> call(
    TransactionType transactionType,
    TransactionDetailsModel transaction,
  ) async {
    await repository.addTransaction(transactionType, transaction);
  }
}
