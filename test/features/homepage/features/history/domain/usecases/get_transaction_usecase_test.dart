import 'package:expense_tracker/features/homepage/features/history/domain/repository/history_repository.dart';
import 'package:expense_tracker/features/homepage/features/history/domain/usecases/get_transaction_usecase.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import 'package:expense_tracker/ui/models/trasaction_details_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

void main() {
  late GetTransactionsUsecase usecase;
  late MockHistoryRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(TransactionType.income);
  });

  setUp(() {
    mockRepository = MockHistoryRepository();
    usecase = GetTransactionsUsecase(mockRepository);
  });

  test('should get transactions from repository', () async {
    const tType = TransactionType.income;
    final tTransactions = [
      TransactionDetailsModel(
        id: '1',
        transactionCategoryLabel: 'Salary',
        transactionCategoryIcon: 'icon',
        transactionSourceLabel: 'Bank',
        transactionSourceIcon: 'icon',
        notes: 'Monthly',
        amount: 1000,
        dateTime: DateTime(2023),
      ),
    ];
    when(
      () => mockRepository.getTransaction(any()),
    ).thenAnswer((_) async => tTransactions);

    final result = await usecase(tType);

    expect(result, tTransactions);
    verify(() => mockRepository.getTransaction(tType)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
