import '../../../../config/theme_helper.dart';
import 'add_income_page.dart';
import 'income_source.dart';
import 'income_type.dart';
import 'package:flutter/material.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  late bool isSource;
  @override
  void initState() {
    super.initState();

    isSource = false;
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSource = false;
                    });
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: (isSource == false)
                            ? BorderSide(width: 3, color: ThemeHelper.primary)
                            : BorderSide.none,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Type',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: ThemeHelper.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Vertical divider between the two tabs
              Container(
                width: 1,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: Theme.of(context).dividerColor,
              ),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSource = true;
                    });
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: (isSource == true)
                            ? BorderSide(width: 3, color: ThemeHelper.primary)
                            : BorderSide.none,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Source',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: ThemeHelper.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          (isSource == false)
              ? Expanded(child: IncomeTypeWidget(onItemSelected: (value) {}))
              : Expanded(child: IncomeSourceWidget(onItemSelected: (value) {})),
        ],
      ),
    );
  }
}

class IncomeFAB extends StatefulWidget {
  const IncomeFAB({super.key});

  @override
  State<IncomeFAB> createState() => _IncomeFABState();
}

class _IncomeFABState extends State<IncomeFAB> {
  final addCategoryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: ThemeHelper.onSurface,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddIncomePage()),
        );
      },
      icon: Icon(Icons.add, color: ThemeHelper.surface),
      label: Text(
        'Add Income',
        style: Theme.of(
          context,
        ).textTheme.titleLarge!.copyWith(color: ThemeHelper.surface),
      ),
    );
  }
}
