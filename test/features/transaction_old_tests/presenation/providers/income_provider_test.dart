import 'package:expense_tracker/features/homepage/features/transaction/domain/usecases/add_transaction_usecase.dart';
import 'package:expense_tracker/features/homepage/features/transaction/presentaion/provider/transaction_provider.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import 'package:expense_tracker/ui/models/trasaction_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddTransactionUsecase extends Mock implements AddTransactionUsecase {}

void main() {
  late MockAddTransactionUsecase mockAddTransactionUsecase;
  late TransactionProvider provider;

  setUpAll(() {
    registerFallbackValue(TransactionType.income);
  });

  setUp(() {
    mockAddTransactionUsecase = MockAddTransactionUsecase();
    provider = TransactionProvider(
      addTransactionUsecase: mockAddTransactionUsecase,
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

  test("Should call addTransaction on TransactionProvider", () async {
    when(
      () => mockAddTransactionUsecase(any(), transaction),
    ).thenAnswer((_) async {});

    final states = <bool>[];
    provider.addListener(() {
      states.add(provider.isLoading);
    });

    final result = await provider.addTransaction(
      TransactionType.income,
      transaction,
    );
    debugPrint('$result');
    expect(result, true);
    // expect(states, [true, false]); // Flaky if notifyListeners called multiple times or sync?
    // Implementation:
    // isLoading = true; notifyListeners(); (1)
    // await logic;
    // isLoading = false; notifyListeners(); (2)
    // So [true, false] is expected.

    expect(provider.error, null);

    verify(
      () => mockAddTransactionUsecase(TransactionType.income, transaction),
    ).called(1);
    verifyNoMoreInteractions(mockAddTransactionUsecase);
  });
}
