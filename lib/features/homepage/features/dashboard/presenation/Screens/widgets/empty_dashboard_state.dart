import 'package:expense_tracker/config/theme_helper.dart';
import 'package:expense_tracker/features/homepage/features/transaction/presentaion/screens/add_transaction_page.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import 'package:flutter/material.dart';

class EmptyDashboardState extends StatelessWidget {
  const EmptyDashboardState({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon Background with concentric circles for a "pulse" effect visual
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: ThemeHelper.secondary.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: ThemeHelper.secondary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Icon(
                    Icons.donut_small_rounded, // Abstract chart icon
                    size: 64,
                    color: ThemeHelper.secondary,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Text Content
              Text(
                'No Data to Analyze',
                style: ThemeHelper.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ThemeHelper.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Your dashboard is looking a bit empty.\nAdd your first transaction to unlock powerful insights and track your financial journey.',
                style: ThemeHelper.bodyLarge?.copyWith(
                  color: ThemeHelper.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddTransactionPage(
                          transactionType: TransactionType.expense,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeHelper.secondary,
                    foregroundColor: ThemeHelper.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_circle_outline_rounded),
                      const SizedBox(width: 8),
                      Text(
                        'Add First Transaction',
                        style: ThemeHelper.titleMedium?.copyWith(
                          color: ThemeHelper.surface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
