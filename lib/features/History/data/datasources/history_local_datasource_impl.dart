import 'package:expense_tracker/features/History/domain/datasource/history_local_datasource.dart';
import 'package:expense_tracker/features/income/domain/entity/income_details_model.dart';
import 'package:hive/hive.dart';

class HistoryLocalDatasourceImpl implements HistoryLocalDataSource {
  @override
  Future<void> cacheIncomeHistory(List<IncomeDetailsModel> incomes) async {
    final box = await Hive.openBox('incomes');
    for (final income in incomes) {
      await box.put(income.id, {...income.toJson(), 'id': income.id});
    }
  }

  @override
  Future<List<IncomeDetailsModel>> getIncome() async {
    final box = await Hive.openBox('incomes');
    return box.values
        .map(
          (e) => IncomeDetailsModel.fromJson(
            Map<String, dynamic>.from(e),
            e['id'],
          ),
        )
        .toList();
  }
  
  @override
  Future<void> deleteAllIncome() async {
    final box = await Hive.openBox('incomes');
    await box.clear();
  }
  
  @override
  Future<void> deleteParticularIncome(String id) async {
    final box = Hive.box('incomes');
    return await  box.delete(id);
  }
}
