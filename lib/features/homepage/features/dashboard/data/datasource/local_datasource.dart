import 'package:expense_tracker/features/homepage/features/history/data/datasources/history_local_datasource_impl.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import 'package:expense_tracker/ui/models/trasaction_details_model.dart';

class DashboardLocalDatasource {
  final HistoryLocalDatasourceImpl historyLocalDatasourceImpl;

  DashboardLocalDatasource({required this.historyLocalDatasourceImpl});

  Future<List<TransactionDetailsModel>> getTransaction(TransactionType transactionType) async {
    return await historyLocalDatasourceImpl.getTransaction(transactionType);
  }
}
