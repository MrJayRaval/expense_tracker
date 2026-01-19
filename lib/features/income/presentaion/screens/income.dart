import 'package:expense_tracker/features/category/presenation/providers/category_provider.dart';
import 'package:expense_tracker/features/income/presentaion/screens/add_income_page.dart';
import 'package:expense_tracker/features/income/presentaion/screens/income_source.dart';
import 'package:expense_tracker/features/income/presentaion/screens/income_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final category = context.watch<CategoryProvider>();

    if (category.isLoading && category.categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

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
                            ? BorderSide(
                                width: 3,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : BorderSide.none,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Type',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
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
                            ? BorderSide(
                                width: 3,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : BorderSide.none,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Source',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          (isSource == false) ? Expanded(child: IncomeTypeWidget(onItemSelected: (value) {  },)) : Expanded(child: IncomeSourceWidget(onItemSelected: (value) {  },)),
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
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddIncomePage()),
        );
      },
      icon: Icon(Icons.add, color: Theme.of(context).colorScheme.surface),
      label: Text(
        'Add Income',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }
}
