import 'package:expense_tracker/config/theme_helper.dart';
import 'package:expense_tracker/features/income/domain/entity/income_type_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IncomeTypeWidget extends StatelessWidget {
  final ValueChanged onItemSelected;
  final int? selectedIndex;
  const IncomeTypeWidget({
    super.key,
    required this.onItemSelected,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: incomeTypeModel.length,
      itemBuilder: (BuildContext context, int index) {
        var item = incomeTypeModel[index];
        final bool isSelected = selectedIndex == index;
        return Card(
          child: ListTile(
            onTap: () => {
              onItemSelected({'icon': item['icon'], 'label': item['label']}),
            },
            selected: isSelected,
            selectedTileColor: ThemeHelper.onSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
            tileColor: ThemeHelper.onPrimary,
            leading: SvgPicture.asset(
              item['icon']!,
              height: 30,
              colorFilter: ColorFilter.mode(
                ThemeHelper.secondary,
                BlendMode.srcIn,
              ),
            ),
            title: Text(item['label']!),
          ),
        );
      },
    );
  }
}
