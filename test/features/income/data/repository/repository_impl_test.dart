import '../../../../../linux/lib/features/income/data/repository/income_repository_impl.dart';
import '../../../../../linux/lib/features/income/domain/datasource/data_remote_source.dart';
import '../../../../../linux/lib/features/income/domain/entity/income_details_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIncomeDataSource extends Mock implements IncomeDataSource {}

void main() {
  late MockIncomeDataSource mockIncomeDataSource;
  late IncomeRepositoryImpl repository;

  setUp(() {
    mockIncomeDataSource = MockIncomeDataSource();
    repository = IncomeRepositoryImpl(remote: mockIncomeDataSource);
  });

  test('Should call addIncome on datasource', () async {
    IncomeDetailsModel income = IncomeDetailsModel(
      incomeTypeLabel: 'Food',
      incomeTypeIcon: 'any',
      incomeSourceLabel: 'incomeSourceLabel',
      incomeSourceIcon: 'incomeSourceIcon',
      notes: 'notes',
      amount: 50,
      dateTime: DateTime(2025),
    );

    when(() => mockIncomeDataSource.addIncome(income)).thenAnswer((_) async {});

    repository.addIncome(income);

    verify(() => mockIncomeDataSource.addIncome(income)).called(1);
    verifyNoMoreInteractions(mockIncomeDataSource);
  });

  test('Should throw exception when addIncome fails', () async {
    IncomeDetailsModel income = IncomeDetailsModel(
      incomeTypeLabel: 'Food',
      incomeTypeIcon: 'any',
      incomeSourceLabel: 'incomeSourceLabel',
      incomeSourceIcon: 'incomeSourceIcon',
      notes: 'notes',
      amount: 50,
      dateTime: DateTime(2025),
    );

    when(
      () => mockIncomeDataSource.addIncome(income),
    ).thenThrow(Exception('Income Addition Failed'));

    expectLater(
      repository.addIncome(income),
      throwsA(isA<Exception>()),
    );
  });
}
