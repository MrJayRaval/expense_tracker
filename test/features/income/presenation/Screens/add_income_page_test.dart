import 'package:expense_tracker/config/theme_helper.dart';
import 'package:expense_tracker/features/income/domain/entity/income_details_model.dart';
import 'package:expense_tracker/features/income/presentaion/provider/income_provider.dart';
import 'package:expense_tracker/features/income/presentaion/screens/add_income_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockIncomeProvider extends Mock implements IncomeProvider {}

Widget createWidgetUnderTest(IncomeProvider provider) {
  return MaterialApp(
    home: ChangeNotifierProvider<IncomeProvider>.value(
    builder: (context, child) {
      ThemeHelper.init(context);
      return child!;
    },
      value: provider,
      child: AddIncomePage(),
    ),
  );
}

void main() {
  late MockIncomeProvider mockIncomeProvider;

  IncomeDetailsModel income = IncomeDetailsModel(
      incomeTypeLabel: 'Food',
      incomeTypeIcon: 'any',
      incomeSourceLabel: 'incomeSourceLabel',
      incomeSourceIcon: 'incomeSourceIcon',
      notes: 'notes',
      amount: 50,
      dateTime: DateTime(2025),
    );
  setUp(() {
    mockIncomeProvider = MockIncomeProvider();

    when(() => mockIncomeProvider.isLoading).thenReturn(false);
    when(() => mockIncomeProvider.error).thenReturn(null);
    when(
      () => mockIncomeProvider.addIncome(income),
    ).thenAnswer((_) async => true);
  });

  testWidgets('Add Income Page renders all UI elements', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest(mockIncomeProvider));

    expect(find.text('Income Type'), findsOneWidget);
  });
}
