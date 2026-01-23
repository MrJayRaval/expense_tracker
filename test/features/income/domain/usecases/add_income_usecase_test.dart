import 'package:expense_tracker/features/income/data/repository/income_repository_impl.dart';
import 'package:expense_tracker/features/income/domain/entity/income_details_model.dart';
import 'package:expense_tracker/features/income/domain/usecases/add_income_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIncomeRepository extends Mock implements IncomeRepositoryImpl {}

void main() {
  late MockIncomeRepository mockIncomeRepository;
  late AddIncomeUsecase addIncomeUsecase;

  setUp(() {
    mockIncomeRepository = MockIncomeRepository();
    addIncomeUsecase = AddIncomeUsecase(repository: mockIncomeRepository);
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

  test("Should call addIncome on AddIncomeUsecase", () async {
    when(() => mockIncomeRepository.addIncome(income)).thenAnswer((_) async {});

    await addIncomeUsecase.addIncome(income);

    verify(() => mockIncomeRepository.addIncome(income)).called(1);
    verifyNoMoreInteractions(mockIncomeRepository);
  });

  test("Should throw exception when addIncome fails", () async {
    when(
      () => mockIncomeRepository.addIncome(income),
    ).thenThrow(Exception('Income Addition Failed'));

    expectLater(
      () => mockIncomeRepository.addIncome(income),
      throwsA(isA<Exception>()),
    );
  });
}
