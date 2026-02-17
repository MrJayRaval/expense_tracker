import 'package:expense_tracker/features/homepage/features/dashboard/presenation/providers/dashboard_provider.dart';
import 'package:expense_tracker/ui/models/trasaction_details_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DashboardProvider provider;

  setUp(() {
    provider = DashboardProvider();
  });

  test('updateData should calculate totals and distributions correctly', () {
    final tIncome = [
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
      TransactionDetailsModel(
        id: '2',
        transactionCategoryLabel: 'Salary',
        transactionCategoryIcon: 'icon',
        transactionSourceLabel: 'Cash',
        transactionSourceIcon: 'icon',
        notes: 'Bonus',
        amount: 500,
        dateTime: DateTime(2023),
      ),
    ];
    final tExpense = [
      TransactionDetailsModel(
        id: '3',
        transactionCategoryLabel: 'Food',
        transactionCategoryIcon: 'icon',
        transactionSourceLabel: 'Cash',
        transactionSourceIcon: 'icon',
        notes: 'Burger',
        amount: 20,
        dateTime: DateTime(2023),
      ),
    ];

    provider.updateData(tIncome, tExpense);

    expect(provider.incomeTotal, 1500.0);
    expect(provider.expenseTotal, 20.0);

    // Distribution
    final incomeDist = provider.incomeDistribution;
    expect(incomeDist.length, 1);
    expect(incomeDist.first.label, 'Salary');
    expect(incomeDist.first.amount, 1500.0);
    expect(incomeDist.first.percentage, closeTo(100.0, 0.0001));

    final expenseDist = provider.expenseDistribution;
    expect(expenseDist.length, 1);
    expect(expenseDist.first.label, 'Food');
    expect(expenseDist.first.amount, 20.0);
    expect(expenseDist.first.percentage, closeTo(100.0, 0.0001));
  });
}
