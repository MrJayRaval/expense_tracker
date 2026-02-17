import 'package:expense_tracker/features/homepage/features/history/domain/repository/history_repository.dart';
import 'package:expense_tracker/features/homepage/features/history/domain/usecases/update_transaction_usecase.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import 'package:expense_tracker/ui/models/trasaction_details_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

void main() {
  late UpdateTransactionUsecase usecase;
  late MockHistoryRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(TransactionType.income);
    registerFallbackValue(
      TransactionDetailsModel(
        transactionCategoryLabel: 'a',
        transactionCategoryIcon: 'a',
        transactionSourceLabel: 'a',
        transactionSourceIcon: 'a',
        notes: 'a',
        amount: 1,
        dateTime: DateTime.now(),
      ),
    );
  });

  setUp(() {
    mockRepository = MockHistoryRepository();
    usecase = UpdateTransactionUsecase(repository: mockRepository);
  });

  test('should update transaction in repository', () async {
    const tType = TransactionType.expense;
    final tTransaction = TransactionDetailsModel(
      id: '1',
      transactionCategoryLabel: 'Food',
      transactionCategoryIcon: 'icon',
      transactionSourceLabel: 'Cash',
      transactionSourceIcon: 'icon',
      notes: 'Burger',
      amount: 20,
      dateTime: DateTime(2023),
    );

    when(
      () => mockRepository.updateTransaction(any(), any()),
    ).thenAnswer((_) async => {});

    await usecase(tType, tTransaction);

    verify(
      () => mockRepository.updateTransaction(tType, tTransaction),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
