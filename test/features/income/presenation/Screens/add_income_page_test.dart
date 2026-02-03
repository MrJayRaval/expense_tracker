import 'package:expense_tracker/config/theme_helper.dart';
import 'package:expense_tracker/features/homepage/features/transaction/presentaion/provider/transaction_provider.dart';
import 'package:expense_tracker/features/homepage/features/transaction/presentaion/screens/add_transaction_page.dart';
import 'package:expense_tracker/ui/models/trasaction_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockTransactionProvider extends Mock implements TransactionProvider {}

Widget createWidgetUnderTest(TransactionProvider provider) {
  return MaterialApp(
    home: ChangeNotifierProvider<TransactionProvider>.value(
      builder: (context, child) {
        ThemeHelper.init(context);
        return child!;
      },
      value: provider,
      child: AddTransactionPage(transactionType: any()),
    ),
  );
}

void main() {
  late MockTransactionProvider mockTransactionProvider;

  TransactionDetailsModel income = TransactionDetailsModel(
    notes: 'notes',
    amount: 50,
    dateTime: DateTime(2025),
    transactionCategoryLabel: '',
    transactionCategoryIcon: '',
    transactionSourceLabel: '',
    transactionSourceIcon: '',
  );
  setUp(() {
    mockTransactionProvider = MockTransactionProvider();

    when(() => mockTransactionProvider.isLoading).thenReturn(false);
    when(() => mockTransactionProvider.error).thenReturn(null);
    when(
      () => mockTransactionProvider.addTransaction(any(), income),
    ).thenAnswer((_) async => true);
  });

  testWidgets('Add Income Page renders all UI elements', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest(mockTransactionProvider));

    expect(find.text('Income Type'), findsOneWidget);
  });
}
