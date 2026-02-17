import 'package:expense_tracker/ui/models/enum.dart';

import '../../../../../../config/theme_helper.dart';
import 'package:expense_tracker/features/homepage/features/category/presenation/providers/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionSourceWidget extends StatelessWidget {
  final ValueChanged onItemSelected;
  final TransactionType transactionType;
  const TransactionSourceWidget({
    super.key,
    required this.onItemSelected,
    this.transactionType = TransactionType.income,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SourceProvider>(
      builder: (context, provider, _) => _buildList(provider),
    );
  }

  Widget _buildList(dynamic provider) {
    if (provider.isLoading && provider.categories.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.load();
      });
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.categories.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.load();
      });
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: provider.categories.length,
      itemBuilder: (BuildContext context, int index) {
        final item = provider.categories.elementAt(index);
        return Card(
          child: ListTile(
            onTap: () {
              onItemSelected({'icon': item.icon, 'label': item.label});
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            tileColor: ThemeHelper.onPrimary,
            leading: SvgPicture.asset(
              item.icon,
              height: 30,
            colorFilter: ColorFilter.mode(ThemeHelper.primary, BlendMode.srcIn),
            ),

            title: Text(item.label),
          ),
        );
      },
    );
  }
}
