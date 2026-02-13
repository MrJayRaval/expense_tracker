import 'package:expense_tracker/ui/models/enum.dart';

import '../../domain/datasource/history_local_datasource.dart';
import '../../domain/datasource/history_remote_datasource.dart';
import '../../domain/repository/history_repository.dart';
import '../../../../../../ui/models/trasaction_details_model.dart';
import 'package:flutter/material.dart';

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
  Future<List<TransactionDetailsModel>> getTransaction(
    TransactionType transactionType,
  ) async {
    final localData = await local.getTransaction(transactionType);

    // Try to fetch remote data first. If successful, cache and return it so
    // the UI gets the up-to-date remote data on first load.
    try {
      final remoteData = await remote
          .fetchTransactionHistory(transactionType)
          .timeout(const Duration(seconds: 5));
      if (remoteData.isNotEmpty) {
        await local.cacheTransactionHistory(transactionType, remoteData);
      } else {
        await local.deleteAllTransaction(transactionType);
      }
      return remoteData;
    } catch (_) {
      // ignore and fall back to local
    }

    // If remote fetch failed or returned empty, fall back to local cache.
    return localData;
  }

  @override
  Future<void> deleteParticularTransaction(
    TransactionType transactionType,
    String id,
  ) async {
    await local.deleteParticularTransaction(transactionType, id);

    try {
      await remote.deleteParticularTransaction(transactionType, id);
    } catch (e) {
      debugPrint('Error deleting income: $e');
    }
  }

  @override
  Future<void> updateTransaction(
    TransactionType transactionType,
    TransactionDetailsModel income,
  ) async {
    await local.updateTransaction(transactionType, income);
    try {
      remote.updateTransaction(transactionType, income);
    } catch (_) {
      // ignore
    }
  }

  @override
  Map<DateTime, List<TransactionDetailsModel>> groupByDate(
    List<TransactionDetailsModel> income,
  ) {
    return local.groupByDate(income);
  }
}
