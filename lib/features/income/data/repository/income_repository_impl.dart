import 'package:expense_tracker/features/income/domain/datasource/data_remote_source.dart';
import 'package:expense_tracker/features/income/domain/entity/income_details_model.dart';
import 'package:expense_tracker/features/income/domain/repository/income_repository.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  final AddIncomeDataSource remote;

  IncomeRepositoryImpl({required this.remote});
  @override
  Future<void> addIncome(IncomeDetailsModel income) async {
    await remote.addIncome(income);
  }
}
