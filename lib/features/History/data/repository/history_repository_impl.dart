import 'package:expense_tracker/features/History/domain/datasource/history_local_datasource.dart';
import 'package:expense_tracker/features/History/domain/datasource/history_remote_datasource.dart';
import 'package:expense_tracker/features/History/domain/repository/history_repository.dart';
import 'package:expense_tracker/features/income/domain/entity/income_details_model.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDataSource local;
  final HistoryRemoteDataSource remote;

  HistoryRepositoryImpl({required this.local, required this.remote});
  @override
  /// Caches the given income history data in local storage.
  /// The data is stored in Hive box with the key as the income ID.
  /// If the data already exists in the box, it will be overwritten.
  /// If the data does not exist in the box, it will be added.
  /// The data is cached in the local storage so that it can be accessed
  /// even when the app is offline.
  ///
  Future<List<IncomeDetailsModel>> getIncome() async {
    // Try to fetch remote data first. If successful, cache and return it so
    // the UI gets the up-to-date remote data on first load.
    try {
      final remoteData = await remote.fetchIncomeHistory();
      if (remoteData.isNotEmpty) {
        await local.cacheIncomeHistory(remoteData);
        return remoteData;
      } else {
        await local.deleteAllIncome();
      }
    } catch (_) {
      // ignore and fall back to local
    }

    // If remote fetch failed or returned empty, fall back to local cache.
    final localData = await local.getIncome();
    return localData;
  }

  @override
  Future<void> deleteParticularIncome(String id) async {
    await local.deleteParticularIncome(id);

    try {
      await remote.deleteParticularIncome(id);
    } catch (_) {
      // ignore
    }
    
  }
}
