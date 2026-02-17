import '../../../../../../config/theme_helper.dart';
import 'package:expense_tracker/ui/models/enum.dart';
import 'package:expense_tracker/features/homepage/features/category/presenation/providers/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionCategoryWidget extends StatelessWidget {
  final TransactionType transactionType;
  final ValueChanged onItemSelected;
  final int? selectedIndex;

  const TransactionCategoryWidget({
    super.key,
    required this.onItemSelected,
    this.selectedIndex,
    this.transactionType = TransactionType.expense,
  });

  @override
  Widget build(BuildContext context) {
    if (transactionType == TransactionType.income) {
      return Consumer<IncomeCategoryProvider>(
        builder: (context, provider, _) => _buildList(provider),
      );
    } else {
      return Consumer<ExpenseCategoryProvider>(
        builder: (context, provider, _) => _buildList(provider),
      );
    }
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
        final item = provider.categories[index];
        final bool isSelected = selectedIndex == index;
        return Card(
          child: ListTile(
            onTap: () {
              onItemSelected({'icon': item.icon, 'label': item.label});
            },
            selected: isSelected,
            selectedTileColor: ThemeHelper.onSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            tileColor: ThemeHelper.onPrimary,
            leading: SvgPicture.asset(
              item.icon,
              height: 30,
              colorFilter:transactionType == TransactionType.expense ? ColorFilter.mode(
                ThemeHelper.primary,
                BlendMode.srcIn,
              ):null,
            ),
            title: Text(item.label),
          ),
        );
      },
    );
  }
}
