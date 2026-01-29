import '../../../../../linux/lib/features/income/domain/entity/income_details_model.dart';
import '../../../../../linux/lib/features/income/domain/usecases/add_income_usecase.dart';
import '../../../../../linux/lib/features/income/presentaion/provider/income_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddIncomeUsecase extends Mock implements AddIncomeUsecase {}

void main() {
  late MockAddIncomeUsecase mockAddIncomeUsecase;
  late IncomeProvider provider;

  setUp(() {
    mockAddIncomeUsecase = MockAddIncomeUsecase();
    provider = IncomeProvider(addIncomeUsecase: mockAddIncomeUsecase);
  });

  IncomeDetailsModel income = IncomeDetailsModel(
    incomeTypeLabel: 'Food',
    incomeTypeIcon: 'any',
    incomeSourceLabel: 'incomeSourceLabel',
    incomeSourceIcon: 'incomeSourceIcon',
    notes: 'notes',
    amount: 50,
    dateTime: DateTime(2025),
  );

  test("Should call addIncome on IncomeProvider", () async {
    when(() => mockAddIncomeUsecase(income)).thenAnswer((_) async {});

    final states = <bool>[];
    provider.addListener(() {
      states.add(provider.isLoading);
    });

    final result = await provider.addIncome(income);
    debugPrint('$result');
    expect(result, true);
    expect(states, [true, false]);
    expect(provider.error, null);

    verify(() => mockAddIncomeUsecase(income)).called(1);
    verifyNoMoreInteractions(mockAddIncomeUsecase);
  });
}
