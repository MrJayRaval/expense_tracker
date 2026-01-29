import '../../../../config/theme_helper.dart';
import '../../domain/entity/income_source_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IncomeSourceWidget extends StatelessWidget {
  final ValueChanged onItemSelected;
  const IncomeSourceWidget({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: incomeSourceModel.length,
      itemBuilder: (BuildContext context, int index) {
        var item = incomeSourceModel[index];
        return Card(
          child: ListTile(
            onTap: () => {
              onItemSelected({'icon': item['icon'], 'label': item['label']}),
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
            tileColor: ThemeHelper.onPrimary,
            leading: SvgPicture.asset(item['icon']!, height: 30),
            title: Text(item['label']!),
          ),
        );
      },
    );
  }
}
