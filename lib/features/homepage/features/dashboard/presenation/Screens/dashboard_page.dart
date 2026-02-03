import 'package:expense_tracker/config/theme_helper.dart';
import 'package:expense_tracker/features/homepage/features/dashboard/presenation/providers/dashboard_provider.dart';
import 'package:expense_tracker/features/homepage/features/transaction/presentaion/screens/add_transaction_page.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    // Totals are provided asynchronously; use FutureBuilder where needed.
    return Scaffold(
      floatingActionButton: AddTransactionFAB(),
      body: Column(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: ThemeHelper.outlineVariant, width: 0.5),
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 5),
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Text(
                          TransactionType.income.name.capitalizeFirst!,
                          style: ThemeHelper.bodyLarge?.copyWith(
                            color: ThemeHelper.onSurface,
                          ),
                        ),
                        SizedBox(height: 5),
                        FutureBuilder<double>(
                          future: provider.totalOfTransaction(TransactionType.income),
                          builder: (context, snapshot) {
                            final val = snapshot.data ?? 0.0;
                            return Text(
                              '₹${val.toStringAsFixed(2)}',
                              style: ThemeHelper.titleMedium!.copyWith(
                                color: ThemeHelper.secondary,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),),

                  Container(width: 0.5, color: ThemeHelper.outlineVariant),

                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 5),
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          Text(
                            TransactionType.expense.name.capitalizeFirst!,
                            style: ThemeHelper.bodyLarge?.copyWith(
                              color: ThemeHelper.onSurface,
                            ),
                          ),
                          SizedBox(height: 5),
                          FutureBuilder<double>(
                            future: provider.totalOfTransaction(TransactionType.expense),
                            builder: (context, snapshot) {
                              final val = snapshot.data ?? 0.0;
                              return Text(
                                '₹${val.toStringAsFixed(2)}',
                                style: ThemeHelper.titleMedium!.copyWith(
                                  color: ThemeHelper.onSurface,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
              ],
              ),
            
            ),
        ],
      ),
    );
  }
}
