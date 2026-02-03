import 'package:expense_tracker/features/homepage/features/transaction/domain/usecases/add_income_usecase.dart';
import 'package:expense_tracker/features/homepage/features/transaction/presentaion/provider/transaction_provider.dart';
import 'package:expense_tracker/ui/models/trasaction_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddIncomeUsecase extends Mock implements AddIncomeUsecase {}

void main() {
  late MockAddIncomeUsecase mockAddIncomeUsecase;
  late TransactionProvider provider;

  setUp(() {
    mockAddIncomeUsecase = MockAddIncomeUsecase();
    provider = TransactionProvider(addIncomeUsecase: mockAddIncomeUsecase);
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
    when(() => mockAddIncomeUsecase(any(), transaction)).thenAnswer((_) async {});

    final states = <bool>[];
    provider.addListener(() {
      states.add(provider.isLoading);
    });

    final result = await provider.addTransaction(any(), transaction);
    debugPrint('$result');
    expect(result, true);
    expect(states, [true, false]);
    expect(provider.error, null);

    verify(() => mockAddIncomeUsecase(any(), transaction)).called(1);
    verifyNoMoreInteractions(mockAddIncomeUsecase);
  });
}
