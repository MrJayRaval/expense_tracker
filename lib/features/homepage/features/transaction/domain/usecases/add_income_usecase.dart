import 'package:expense_tracker/ui/models/enum.dart';

import '../../../../../../ui/models/trasaction_details_model.dart';
import '../repository/income_repository.dart';

class AddIncomeUsecase {
  final IncomeRepository repository;

  AddIncomeUsecase({required this.repository});

  Future<void> call(TransactionType transactionType,TransactionDetailsModel income) async {
    await repository.addTransaction(transactionType, income);
  }
}
