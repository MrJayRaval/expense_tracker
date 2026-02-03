import 'package:expense_tracker/features/homepage/features/transaction/presentaion/provider/transaction_provider.dart';
import 'package:expense_tracker/features/homepage/features/transaction/presentaion/screens/income_page.dart';
import 'package:flutter/material.dart';

Widget createWidgetUnderTest(TransactionProvider provider) {
  return MaterialApp(home: IncomePage());
}
