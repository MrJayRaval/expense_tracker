import '../../../../config/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HistoryTile extends StatelessWidget {
  final String incomeTypeIcon;
  final String incomeTypeLabel;
  final String incomeSourceLabel;
  final String incomeSourceIcon;
  final double amount;
  const HistoryTile({
    super.key,
    required this.incomeTypeIcon,
    required this.incomeTypeLabel,
    required this.incomeSourceLabel,
    required this.incomeSourceIcon,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: ThemeHelper.onTertiary.withAlpha(160),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ThemeHelper.outline)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: ThemeHelper.surface,
            radius: 22,
            child: SvgPicture.asset(incomeTypeIcon, height: 27, colorFilter: ColorFilter.mode(ThemeHelper.secondary, BlendMode.srcIn),),
          ),

          SizedBox(width: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Text(incomeTypeLabel, style: ThemeHelper.bodyLarge)],
                    ),

                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          incomeSourceIcon,
                          height: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          incomeSourceLabel,
                          style: ThemeHelper.bodyMedium!.copyWith(
                            color: ThemeHelper.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Text('₹ $amount', style: ThemeHelper.bodyLarge!.copyWith(color: ThemeHelper.secondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
