import 'package:expense_tracker/features/homepage/features/transaction/domain/usecases/add_transaction_usecase.dart';
import 'package:expense_tracker/features/homepage/features/transaction/presentaion/provider/transaction_provider.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import 'package:expense_tracker/ui/models/trasaction_details_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddTransactionUsecase extends Mock implements AddTransactionUsecase {}

void main() {
  late TransactionProvider provider;
  late MockAddTransactionUsecase mockAdd;

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
    mockAdd = MockAddTransactionUsecase();
    provider = TransactionProvider(addTransactionUsecase: mockAdd);
  });

  test(
    'addTransaction should call usecase and return true and reset error',
    () async {
      final tTransaction = TransactionDetailsModel(
        transactionCategoryLabel: 'Salary',
        transactionCategoryIcon: 'icon',
        transactionSourceLabel: 'Bank',
        transactionSourceIcon: 'icon',
        notes: 'Monthly',
        amount: 1000,
        dateTime: DateTime(2023),
      );

      when(() => mockAdd(any(), any())).thenAnswer((_) async => {});

      final result = await provider.addTransaction(
        TransactionType.income,
        tTransaction,
      );

      expect(result, true);
      expect(provider.error, null);
      expect(provider.isLoading, false);
      verify(() => mockAdd(TransactionType.income, tTransaction)).called(1);
    },
  );

  test('addTransaction should catch error and return false', () async {
    final tTransaction = TransactionDetailsModel(
      transactionCategoryLabel: 'Salary',
      transactionCategoryIcon: 'icon',
      transactionSourceLabel: 'Bank',
      transactionSourceIcon: 'icon',
      notes: 'Monthly',
      amount: 1000,
      dateTime: DateTime(2023),
    );

    // Using thenThrow from Mocktail to simulate exception
    when(() => mockAdd(any(), any())).thenThrow(Exception('Error adding'));

    final result = await provider.addTransaction(
      TransactionType.income,
      tTransaction,
    );

    expect(result, false);
    expect(provider.error, contains('Error adding'));
    expect(provider.isLoading, false);
    verify(() => mockAdd(TransactionType.income, tTransaction)).called(1);
  });
}
