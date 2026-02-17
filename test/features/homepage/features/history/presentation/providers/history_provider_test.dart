import 'package:expense_tracker/features/homepage/features/history/domain/datasource/history_local_datasource.dart';
import 'package:expense_tracker/features/homepage/features/history/domain/usecases/delete_particular_transaction_usecase.dart';
import 'package:expense_tracker/features/homepage/features/history/domain/usecases/get_transaction_usecase.dart';
import 'package:expense_tracker/features/homepage/features/history/domain/usecases/group_by_date_usecase.dart';
import 'package:expense_tracker/features/homepage/features/history/domain/usecases/update_transaction_usecase.dart';
import 'package:expense_tracker/features/homepage/features/history/presenation/providers/history_provider.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import 'package:expense_tracker/ui/models/trasaction_details_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTransactionsUsecase extends Mock
    implements GetTransactionsUsecase {}

class MockHistoryLocalDataSource extends Mock
    implements HistoryLocalDataSource {}

class MockDeleteParticularTransactionUsecase extends Mock
    implements DeleteParticularTransactionUsecase {}

class MockUpdateTransactionUsecase extends Mock
    implements UpdateTransactionUsecase {}

class MockGroupByDateUseCase extends Mock implements GroupByDateUseCase {}

void main() {
  late HistoryProvider provider;
  late MockGetTransactionsUsecase mockGet;
  late MockHistoryLocalDataSource mockLocal;
  late MockDeleteParticularTransactionUsecase mockDelete;
  late MockUpdateTransactionUsecase mockUpdate;
  late MockGroupByDateUseCase mockGroup;

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
    mockGet = MockGetTransactionsUsecase();
    mockLocal = MockHistoryLocalDataSource();
    mockDelete = MockDeleteParticularTransactionUsecase();
    mockUpdate = MockUpdateTransactionUsecase();
    mockGroup = MockGroupByDateUseCase();

    // Mock initial load behavior to avoid constructor crash/hang
    when(() => mockGet(any())).thenAnswer((_) async => []);

    provider = HistoryProvider(
      getTransactionUsecase: mockGet,
      historyLocalDataSource: mockLocal,
      deleteParticularTransactionUsecase: mockDelete,
      updateTransactionUsecase: mockUpdate,
      groupByDateUseCase: mockGroup,
    );
  });

  test('loadTransaction should fetch both income and expense', () async {
    final tTransactions = [
      TransactionDetailsModel(
        id: '1',
        transactionCategoryLabel: 'Salary',
        transactionCategoryIcon: 'icon',
        transactionSourceLabel: 'Bank',
        transactionSourceIcon: 'icon',
        notes: 'Monthly',
        amount: 1000,
        dateTime: DateTime(2023),
      ),
    ];
    when(
      () => mockGet(TransactionType.income),
    ).thenAnswer((_) async => tTransactions);
    when(() => mockGet(TransactionType.expense)).thenAnswer((_) async => []);

    await provider.loadTransaction();

    expect(provider.incomeTransactions, tTransactions);
    expect(provider.expenseTransactions, isEmpty);
    verify(
      () => mockGet(TransactionType.income),
    ).called(greaterThanOrEqualTo(1)); // Constructor calls it too
    verify(
      () => mockGet(TransactionType.expense),
    ).called(greaterThanOrEqualTo(1));
  });

  test(
    'deleteParticularTransaction should remove from list and call usecase',
    () async {
      const tId = '1';
      final tTransaction = TransactionDetailsModel(
        id: tId,
        transactionCategoryLabel: 'Salary',
        transactionCategoryIcon: 'icon',
        transactionSourceLabel: 'Bank',
        transactionSourceIcon: 'icon',
        notes: 'Monthly',
        amount: 1000,
        dateTime: DateTime(2023),
      );

      // Inject initial state via private list access workaround or just verify call
      // Since lists are private but getters return direct reference (usually copy or unmodifiable view on some archs, here direct list)
      // Actually getter returns _incomeTransactions which is a List.
      // So I can modify it if getters return internal list directly.
      // Provider implementation: List<TransactionDetailsModel> get incomeTransactions => _incomeTransactions;
      // Yes, it returns the internal list reference.

      provider.incomeTransactions.add(tTransaction);

      when(() => mockDelete(any(), any())).thenAnswer((_) async => {});

      await provider.deleteParticularTransaction(TransactionType.income, tId);

      expect(provider.incomeTransactions.isEmpty, true);
      verify(() => mockDelete(TransactionType.income, tId)).called(1);
    },
  );
}
