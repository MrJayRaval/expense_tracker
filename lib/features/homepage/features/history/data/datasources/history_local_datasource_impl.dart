import 'package:expense_tracker/ui/models/enum.dart';

import '../../domain/datasource/history_local_datasource.dart';
import '../../../../../../ui/models/trasaction_details_model.dart';
import 'package:hive/hive.dart';

class HistoryLocalDatasourceImpl implements HistoryLocalDataSource {
  @override
  Future<void> cacheTransactionHistory(TransactionType transactionType, List<TransactionDetailsModel> incomes) async {
    final box = Hive.box(transactionType.name);
    for (final income in incomes) {
      await box.put(income.id, {...income.toJson(), 'id': income.id});
    }
  }

  @override
  Future<List<TransactionDetailsModel>> getTransaction(TransactionType transactionType, ) async {
    final box = Hive.box(transactionType.name);
    return box.values
        .map(
          (e) => TransactionDetailsModel.fromJson(
            Map<String, dynamic>.from(e),
            e['id'],
          ),
        )
        .toList();
  }

  @override
  Future<void> deleteAllTransaction(TransactionType transactionType, ) async {
    final box = Hive.box(transactionType.name);
    await box.clear();
  }

  @override
  Future<void> deleteParticularTransaction(TransactionType transactionType, String id) async {
    final box = Hive.box(transactionType.name);
    return await box.delete(id);
  }

  @override
  Future<void> updateTransaction(TransactionType transactionType, TransactionDetailsModel income) async {
    final box = Hive.box(transactionType.name);
    return await box.put(income.id, {...income.toJson(), 'id': income.id});
  }

  /// This function groups the given list of income history by date.
  ///
  /// It will return a map where the key is a DateTime object representing
  /// the date, and the value is a list of TransactionDetailsModel objects
  /// for that date.
  ///
  /// The date is created by using the year, month and day of the
  /// income's dateTime.
  ///
  /// If multiple income history objects have the same date, they will
  /// be grouped together in the same list.
  @override
  Map<DateTime, List<TransactionDetailsModel>> groupByDate(
    List<TransactionDetailsModel> incomes,
  ) {
    final Map<DateTime, List<TransactionDetailsModel>> grouped = {};

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
