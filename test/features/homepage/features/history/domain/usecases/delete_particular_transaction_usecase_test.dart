import 'package:expense_tracker/features/homepage/features/history/domain/repository/history_repository.dart';
import 'package:expense_tracker/features/homepage/features/history/domain/usecases/delete_particular_transaction_usecase.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

void main() {
  late DeleteParticularTransactionUsecase usecase;
  late MockHistoryRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(TransactionType.income);
  });

  setUp(() {
    mockRepository = MockHistoryRepository();
    usecase = DeleteParticularTransactionUsecase(mockRepository);
  });

  test('should delete transaction from repository', () async {
    const tId = '123';
    const tType = TransactionType.expense;
    when(
      () => mockRepository.deleteParticularTransaction(any(), any()),
    ).thenAnswer((_) async => {});

    await usecase(tType, tId);

    verify(
      () => mockRepository.deleteParticularTransaction(tType, tId),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
