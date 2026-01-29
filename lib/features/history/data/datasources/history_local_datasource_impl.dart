import '../../domain/datasource/history_local_datasource.dart';
import '../../../income/domain/entity/income_details_model.dart';
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
    return await box.delete(id);
  }

  @override
  Future<void> updateIncome(IncomeDetailsModel income) async {
    final box = await Hive.openBox('incomes');
    return await box.put(income.id, {...income.toJson(), 'id': income.id});
  }

  /// This function groups the given list of income history by date.
  ///
  /// It will return a map where the key is a DateTime object representing
  /// the date, and the value is a list of IncomeDetailsModel objects
  /// for that date.
  ///
  /// The date is created by using the year, month and day of the
  /// income's dateTime.
  ///
  /// If multiple income history objects have the same date, they will
  /// be grouped together in the same list.
  @override
  Map<DateTime, List<IncomeDetailsModel>> groupByDate(
    List<IncomeDetailsModel> incomes,
  ) {
    final Map<DateTime, List<IncomeDetailsModel>> grouped = {};

    for (final income in incomes) {
      final dateKey = DateTime(
        income.dateTime.year,
        income.dateTime.month,
        income.dateTime.day,
      );
      grouped
          .putIfAbsent(dateKey, () => [])
          .add(income); // grouped.putIfAbsent(key, ifAbsent)
    }

    return grouped;
  }
}
