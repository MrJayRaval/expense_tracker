import '../../../../../../config/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HistoryTile extends StatelessWidget {
  final String transactionCategoryIcon;
  final String transactionCategoryLabel;
  final String transactionSourceLabel;
  final String transactionSourceIcon;
  final double amount;
  final Color? color;

  const HistoryTile({
    super.key,
    required this.transactionCategoryIcon,
    required this.transactionCategoryLabel,
    required this.transactionSourceLabel,
    required this.transactionSourceIcon,
    required this.amount,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: ThemeHelper.surfaceContainerHighest.withAlpha(100),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: ThemeHelper.outline.withValues(alpha: 0.2)),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ThemeHelper.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset(
              transactionCategoryIcon,
              height: 24,
              colorFilter: ColorFilter.mode(
                ThemeHelper.onSecondaryContainer,
                BlendMode.srcIn,
              ),
            ),
          ),
          title: Text(
            transactionCategoryLabel,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: ThemeHelper.onSurface,
            ),
          ),
          subtitle: Row(
            children: [
              SvgPicture.asset(
                transactionSourceIcon,
                height: 16,
                colorFilter: ColorFilter.mode(
                  ThemeHelper.onSurfaceVariant,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                transactionSourceLabel,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ThemeHelper.onSurfaceVariant,
                ),
              ),
            ],
          ),
          trailing: Text(
            '₹ ${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color ?? ThemeHelper.primary,
            ),
          ),
        ),
      ),
    );
  }
}
