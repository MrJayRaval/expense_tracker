import 'package:expense_tracker/ui/models/enum.dart';

import '../../domain/usecases/delete_particular_transaction_usecase.dart';
import '../../domain/usecases/get_transaction_usecase.dart';
import '../../domain/usecases/group_by_date_usecase.dart';
import '../../domain/usecases/update_transaction_usecase.dart';
import '../../../../../../ui/models/trasaction_details_model.dart';
import 'package:flutter/material.dart';

class HistoryProvider extends ChangeNotifier {
  final GetTransactionsUsecase getTransactionUsecase;
  final DeleteParticularTransactionUsecase deleteParticularTransactionUsecase;
  final UpdateTransactionUsecase updateTransactionUsecase;
  final GroupByDateUseCase groupByDateUseCase;

  HistoryProvider({
    required this.getTransactionUsecase,
    required this.deleteParticularTransactionUsecase,
    required this.updateTransactionUsecase,
    required this.groupByDateUseCase,
  });

  bool isLoading = false;
  String? error;
  final List<TransactionDetailsModel> _transactions = [];

  List<TransactionDetailsModel> get transactions => _transactions;

  Future<void> getTransactions(TransactionType transactionType) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final transactions = await getTransactionUsecase(transactionType);
      debugPrint(
        'HistoryProvider: fetched ${transactions.length} transactions from usecase',
      );
      _transactions
        ..clear()
        ..addAll(transactions);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      debugPrint('HistoryProvider.getTransaction error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteParticularTransaction(TransactionType transactionType, String id) async {
    _transactions.removeWhere((element) => element.id == id);
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

  Future<void> updateTransaction(TransactionType transactionType, TransactionDetailsModel transaction) async {
    // Update the in-memory list so UI updates immediately
    final index = _transactions.indexWhere((element) => element.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
      notifyListeners();
    } else {
      // If not found, refresh from source
      try {
        final transactions = await getTransactionUsecase(transactionType, );
        _transactions
          ..clear()
          ..addAll(transactions);
        notifyListeners();
      } catch (e) {
        // ignore
      }
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

  Map<DateTime, List<TransactionDetailsModel>> groupByDate(
    List<TransactionDetailsModel> transactions,
  ) {
    return groupByDateUseCase(transactions);
  }

  void addTransactionToHistory(TransactionDetailsModel transaction) {
    _transactions.insert(0, transaction);
    notifyListeners();
  }
}
