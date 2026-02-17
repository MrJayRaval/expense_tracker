import 'package:expense_tracker/features/homepage/features/transaction/data/repository/transaction_repository_impl.dart';
import 'package:expense_tracker/features/homepage/features/transaction/domain/datasource/data_remote_source.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import 'package:expense_tracker/ui/models/trasaction_details_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionDataSource extends Mock implements TransactionDataSource {}

void main() {
  late MockTransactionDataSource mockTransactionDataSource;
  late TransactionRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(TransactionType.income);
  });

  setUp(() {
    mockTransactionDataSource = MockTransactionDataSource();
    repository = TransactionRepositoryImpl(remote: mockTransactionDataSource);
  });

  test('Should call addTransaction on datasource', () async {
    TransactionDetailsModel transaction = TransactionDetailsModel(
      notes: 'notes',
      amount: 50,
      dateTime: DateTime(2025),
      transactionCategoryLabel: '',
      transactionCategoryIcon: '',
      transactionSourceLabel: '',
      transactionSourceIcon: '',
    );

    when(
      () => mockTransactionDataSource.addTransactions(any(), transaction),
    ).thenAnswer((_) async {});

    await repository.addTransaction(TransactionType.income, transaction);

    verify(
      () => mockTransactionDataSource.addTransactions(
        TransactionType.income,
        transaction,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockTransactionDataSource);
  });

  test('Should throw exception when addTransaction fails', () async {
    TransactionDetailsModel transaction = TransactionDetailsModel(
      transactionCategoryLabel: 'Food',
      transactionCategoryIcon: 'any',
      transactionSourceLabel: 'sourceLabel',
      transactionSourceIcon: 'sourceIcon',
      notes: 'notes',
      amount: 50,
      dateTime: DateTime(2025),
    );

    when(
      () => mockTransactionDataSource.addTransactions(any(), transaction),
    ).thenThrow(Exception('Transaction Addition Failed'));

    expect(
      () => repository.addTransaction(TransactionType.income, transaction),
      throwsA(isA<Exception>()),
    );
  });
}
