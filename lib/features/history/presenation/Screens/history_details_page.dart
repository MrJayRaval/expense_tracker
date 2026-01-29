import '../../../../config/theme_helper.dart';
import '../../../income/domain/entity/income_details_model.dart';
import '../../../income/presentaion/screens/add_income_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class HistoryDetailsPage extends StatelessWidget {
  final void Function()? deleteButtonFunction;
  final String title;
  final IncomeDetailsModel income;
  final BuildContext context;
  final bool isThisExpense;

  const HistoryDetailsPage({
    super.key,
    required this.deleteButtonFunction,
    required this.title,
    required this.income,
    required this.context,
    this.isThisExpense = false,
  });

  @override
  Widget build(BuildContext context) {
    String amount = income.amount.toString();
    String timeStamp = DateFormat(
      'MMM d, yyyy hh:mm a',
    ).format(income.dateTime);
    String notes = (income.notes).isEmpty ? 'No notes' : income.notes;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: ThemeHelper.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      titlePadding: EdgeInsets.all(5),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          ),

          SizedBox(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: ThemeHelper.outline),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          titlePadding: EdgeInsets.all(15),
                          title: Text('Are You sure you want to delete?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No'),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  ThemeHelper.errorContainer,
                                ),
                              ),
                              onPressed: () {
                                try {
                                  if (deleteButtonFunction != null) {
                                    deleteButtonFunction!();
                                  }
                                } catch (_) {
                                } finally {
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                'Yes',
                                style: ThemeHelper.bodyMedium!.copyWith(
                                  color: ThemeHelper.onErrorContainer,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.delete_forever_outlined,
                    color: ThemeHelper.error,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddIncomePage(income: income, isEditMode: true, incomeID: income.id,)));
                  },
                  icon: Icon(Icons.edit_outlined),
                ),
              ],
            ),
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: ThemeHelper.titleLarge),
          SizedBox(height: 10),
          Text(
            isThisExpense ? "- ₹$amount" : "+ ₹$amount",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: isThisExpense ? ThemeHelper.error : ThemeHelper.secondary,
            ),
          ),

          SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Text(timeStamp, style: ThemeHelper.bodySmall)],
          ),
          SizedBox(height: 15),

          Divider(),

          SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Account', style: ThemeHelper.bodyMedium),
                  SizedBox(height: 5),
                  Text('catagory', style: ThemeHelper.bodyMedium),
                ],
              ),

              SizedBox(width: 30),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        income.incomeTypeIcon,
                        height: 15,
                        colorFilter: ColorFilter.mode(
                          ThemeHelper.secondary,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        income.incomeTypeLabel,
                        style: ThemeHelper.bodyMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      SvgPicture.asset(income.incomeSourceIcon, height: 15),
                      SizedBox(width: 5),
                      Text(
                        income.incomeSourceLabel,
                        style: ThemeHelper.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 15),

          Divider(),

          SizedBox(height: 15),

          Text(notes, style: ThemeHelper.bodyMedium),
        ],
      ),
    );
  }
}
