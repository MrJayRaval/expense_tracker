import 'package:expense_tracker/features/homepage/features/category/domain/entities/category_model.dart';
import 'package:expense_tracker/ui/models/enum.dart';

import '../../../../../../config/theme_helper.dart';
import '../../domain/entity/transaction_source_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionSourceWidget extends StatelessWidget {
  final ValueChanged onItemSelected;
  final TransactionType transactionType;
  const TransactionSourceWidget({super.key, required this.onItemSelected, this.transactionType = TransactionType.income});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount:transactionType == TransactionType.income ? incomeSourceModel.length : expenseCategoryEntity.length,
      itemBuilder: (BuildContext context, int index) {
        var item = transactionType == TransactionType.income ? incomeSourceModel[index] : expenseCategoryEntity[index];
        return Card(
          child: ListTile(
            onTap: () => {
              onItemSelected({'icon': item['icon'], 'label': item['label']}),
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
            tileColor: ThemeHelper.onPrimary,
            leading: SvgPicture.asset(item['icon']!, height: 30, colorFilter:transactionType == TransactionType.expense ? ColorFilter.mode(ThemeHelper.onTertiary, BlendMode.srcIn) : null,),
            title: Text(item['label']!),
          ),
        );
      },
    );
  }
}
