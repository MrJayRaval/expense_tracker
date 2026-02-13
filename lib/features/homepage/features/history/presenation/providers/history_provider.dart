import 'package:expense_tracker/features/homepage/features/history/domain/datasource/history_local_datasource.dart';
import 'package:expense_tracker/ui/models/enum.dart';

import '../../domain/usecases/delete_particular_transaction_usecase.dart';
import '../../domain/usecases/get_transaction_usecase.dart';
import '../../domain/usecases/group_by_date_usecase.dart';
import '../../domain/usecases/update_transaction_usecase.dart';
import '../../../../../../ui/models/trasaction_details_model.dart';
import 'package:flutter/material.dart';

class HistoryProvider extends ChangeNotifier {
  final GetTransactionsUsecase getTransactionUsecase;
  final HistoryLocalDataSource historyLocalDataSource;
  final DeleteParticularTransactionUsecase deleteParticularTransactionUsecase;
  final UpdateTransactionUsecase updateTransactionUsecase;
  final GroupByDateUseCase groupByDateUseCase;

  HistoryProvider({
    required this.getTransactionUsecase,
    required this.deleteParticularTransactionUsecase,
    required this.updateTransactionUsecase,
    required this.groupByDateUseCase, 
    required this.historyLocalDataSource,
  }) {
    Future.microtask(loadTransaction);
  }

  bool isLoading = false;
  String? error;
  final List<TransactionDetailsModel> _incomeTransactions = [];
  final List<TransactionDetailsModel> _expenseTransactions = [];

  List<TransactionDetailsModel> get incomeTransactions => _incomeTransactions;
  List<TransactionDetailsModel> get expenseTransactions => _expenseTransactions;

  Future<void> loadTransaction() async {
    isLoading = true;
    error = null;
    notifyListeners(); // This is the one causing the error on startup

    try {
      // Perform both fetches in parallel for better performance
      final results = await Future.wait([
        getTransactionUsecase(TransactionType.income),
        getTransactionUsecase(TransactionType.expense),
      ]);

      _incomeTransactions
        ..clear()
        ..addAll(results[0]);
      _expenseTransactions
        ..clear()
        ..addAll(results[1]);
      notifyListeners();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners(); // Only need one final notification
    }
  }

  Future<void> deleteParticularTransaction(
    TransactionType transactionType,
    String id,
  ) async {
    if (transactionType == TransactionType.income) {
      _incomeTransactions.removeWhere((element) => element.id == id);
    } else {
      _expenseTransactions.removeWhere((element) => element.id == id);
    }
    notifyListeners();
    error = null;

    try {
      await deleteParticularTransactionUsecase(transactionType, id);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTransaction(
    TransactionType transactionType,
    TransactionDetailsModel transaction,
  ) async {
    // Update the in-memory list so UI updates immediately
    if (transactionType == TransactionType.income) {
      final index = _incomeTransactions.indexWhere(
        (element) => element.id == transaction.id,
      );
      if (index != -1) {
        _incomeTransactions[index] = transaction;
        notifyListeners();
      }
      error = null;
      notifyListeners();
      try {
        await updateTransactionUsecase(transactionType, transaction);
        isLoading = false;
        notifyListeners();
      } catch (e) {
        error = e.toString();
        debugPrint('HistoryProvider.updateIncome error: $e');
        isLoading = false;
        notifyListeners();
      }
    } else {
      final index = _expenseTransactions.indexWhere(
        (element) => element.id == transaction.id,
      );
      if (index != -1) {
        _expenseTransactions[index] = transaction;
        notifyListeners();
      }
      error = null;
      notifyListeners();
      try {
        await updateTransactionUsecase(transactionType, transaction);
        isLoading = false;
        notifyListeners();
      } catch (e) {
        error = e.toString();
        debugPrint('HistoryProvider.updateIncome error: $e');
        isLoading = false;
        notifyListeners();
      }
    }
  }

  Map<DateTime, List<TransactionDetailsModel>> groupByDate(
    List<TransactionDetailsModel> transactions,
  ) {
    return groupByDateUseCase(transactions);
  }

  Future<void> addTransactionToHistory(
    TransactionType transactionType,
    TransactionDetailsModel transaction,
  ) async {
    await historyLocalDataSource.cacheTransactionHistory(transactionType, [transaction]);
    transactionType == TransactionType.income
        ? _incomeTransactions.insert(0, transaction)
        : _expenseTransactions.insert(0, transaction);
    notifyListeners();
  }
}
