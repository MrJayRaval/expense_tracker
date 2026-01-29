import '../../domain/datasource/data_remote_source.dart';
import '../../domain/entity/income_details_model.dart';
import '../../domain/repository/income_repository.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  final IncomeDataSource remote;

  IncomeRepositoryImpl({required this.remote});
  @override
  Future<void> addIncome(IncomeDetailsModel income) async {
    await remote.addIncome(income);
  }
}
