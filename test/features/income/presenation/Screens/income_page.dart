import '../../../../../linux/lib/features/income/presentaion/provider/income_provider.dart';
import '../../../../../linux/lib/features/income/presentaion/screens/income_page.dart';
import 'package:flutter/material.dart';

Widget createWidgetUnderTest(IncomeProvider provider) {
  return MaterialApp(home: IncomePage());
}
