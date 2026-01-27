import 'package:expense_tracker/features/History/domain/repository/history_repository.dart';

class DeleteParticularIncomeUsecase {
  final HistoryRepository repository;
  DeleteParticularIncomeUsecase(this.repository);
  Future<void> call(String id) async  => await repository.deleteParticularIncome(id);
}