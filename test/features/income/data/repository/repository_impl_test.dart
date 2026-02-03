import 'package:expense_tracker/features/homepage/features/transaction/data/repository/income_repository_impl.dart';
import 'package:expense_tracker/features/homepage/features/transaction/domain/datasource/data_remote_source.dart';
import 'package:expense_tracker/ui/models/trasaction_details_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIncomeDataSource extends Mock implements TransactionDataSource {}

void main() {
  late MockIncomeDataSource mockIncomeDataSource;
  late IncomeRepositoryImpl repository;

  setUp(() {
    mockIncomeDataSource = MockIncomeDataSource();
    repository = IncomeRepositoryImpl(remote: mockIncomeDataSource);
  });

  test('Should call addTransaction on datasource', () async {
    TransactionDetailsModel income = TransactionDetailsModel(
      notes: 'notes',
      amount: 50,
      dateTime: DateTime(2025),
      transactionCategoryLabel: '',
      transactionCategoryIcon: '',
      transactionSourceLabel: '',
      transactionSourceIcon: '',
    );

    when(
      () => mockIncomeDataSource.addTransactions(any(), income),
    ).thenAnswer((_) async {});

    repository.addTransaction(any(), income);

    verify(() => mockIncomeDataSource.addTransactions(any(), income)).called(1);
    verifyNoMoreInteractions(mockIncomeDataSource);
  });

  test('Should throw exception when addTransaction fails', () async {
    TransactionDetailsModel income = TransactionDetailsModel(
      transactionCategoryLabel: 'Food',
      transactionCategoryIcon: 'any',
      transactionSourceLabel: 'incomeSourceLabel',
      transactionSourceIcon: 'incomeSourceIcon',
      notes: 'notes',
      amount: 50,
      dateTime: DateTime(2025),
    );

    when(
      () => mockIncomeDataSource.addTransactions(any(), income),
    ).thenThrow(Exception('Income Addition Failed'));

    expectLater(repository.addTransaction(any(), income), throwsA(isA<Exception>()));
  });
}
