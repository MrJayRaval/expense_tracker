import 'package:expense_tracker/features/homepage/features/transaction/data/repository/transaction_repository_impl.dart';
import 'package:expense_tracker/features/homepage/features/transaction/domain/usecases/add_transaction_usecase.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import 'package:expense_tracker/ui/models/trasaction_details_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock
    implements TransactionRepositoryImpl {}

void main() {
  late MockTransactionRepository mockTransactionRepository;
  late AddTransactionUsecase addTransactionUsecase;

  setUpAll(() {
    registerFallbackValue(TransactionType.income);
  });

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    addTransactionUsecase = AddTransactionUsecase(
      repository: mockTransactionRepository,
    );
  });

  TransactionDetailsModel transaction = TransactionDetailsModel(
    notes: 'notes',
    amount: 50,
    dateTime: DateTime(2025),
    transactionCategoryLabel: '',
    transactionCategoryIcon: '',
    transactionSourceLabel: '',
    transactionSourceIcon: '',
  );

  test("Should call addTransaction on AddTransactionUsecase", () async {
    when(
      () => mockTransactionRepository.addTransaction(any(), transaction),
    ).thenAnswer((_) async {});

    await addTransactionUsecase(TransactionType.income, transaction);

    verify(
      () => mockTransactionRepository.addTransaction(
        TransactionType.income,
        transaction,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockTransactionRepository);
  });

  test("Should throw exception when addTransaction fails", () async {
    when(
      () => mockTransactionRepository.addTransaction(any(), transaction),
    ).thenThrow(Exception('Transaction Addition Failed'));

    expectLater(
      () => addTransactionUsecase(TransactionType.income, transaction),
      throwsA(isA<Exception>()),
    );
  });
}
