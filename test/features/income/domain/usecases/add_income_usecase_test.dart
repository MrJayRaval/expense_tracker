import 'package:expense_tracker/features/homepage/features/transaction/data/repository/income_repository_impl.dart';
import 'package:expense_tracker/features/homepage/features/transaction/domain/usecases/add_income_usecase.dart';
import 'package:expense_tracker/ui/models/trasaction_details_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIncomeRepository extends Mock implements IncomeRepositoryImpl {}

void main() {
  late MockIncomeRepository mockIncomeRepository;
  late AddTransactionUsecase addTransactionUsecase;

  setUp(() {
    mockIncomeRepository = MockIncomeRepository();
    addTransactionUsecase = AddTransactionUsecase(
      repository: mockIncomeRepository,
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
      () => mockIncomeRepository.addTransaction(any(), transaction),
    ).thenAnswer((_) async {});

    await addTransactionUsecase(any(), transaction);

    verify(
      () => mockIncomeRepository.addTransaction(any(), transaction),
    ).called(1);
    verifyNoMoreInteractions(mockIncomeRepository);
  });

  test("Should throw exception when addTransaction fails", () async {
    when(
      () => mockIncomeRepository.addTransaction(any(), transaction),
    ).thenThrow(Exception('Income Addition Failed'));

    expectLater(
      () => mockIncomeRepository.addTransaction(any(), transaction),
      throwsA(isA<Exception>()),
    );
  });
}
