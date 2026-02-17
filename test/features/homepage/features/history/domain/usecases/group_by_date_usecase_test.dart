import 'package:expense_tracker/features/homepage/features/history/domain/repository/history_repository.dart';
import 'package:expense_tracker/features/homepage/features/history/domain/usecases/group_by_date_usecase.dart';
import 'package:expense_tracker/ui/models/trasaction_details_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

void main() {
  late GroupByDateUseCase usecase;
  late MockHistoryRepository mockRepository;

  setUp(() {
    mockRepository = MockHistoryRepository();
    usecase = GroupByDateUseCase(repository: mockRepository);
  });

  test('should group transactions by date', () {
    final date = DateTime(2023, 1, 1);
    final tTransactions = [
      TransactionDetailsModel(
        id: '1',
        transactionCategoryLabel: 'Food',
        transactionCategoryIcon: 'icon',
        transactionSourceLabel: 'Cash',
        transactionSourceIcon: 'icon',
        notes: 'Burger',
        amount: 20,
        dateTime: date,
      ),
    ];
    final tGrouped = {date: tTransactions};
    when(() => mockRepository.groupByDate(any())).thenReturn(tGrouped);

    final result = usecase(tTransactions);

    expect(result, tGrouped);
    verify(() => mockRepository.groupByDate(tTransactions)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
