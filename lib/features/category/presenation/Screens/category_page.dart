import 'package:expense_tracker/config/colors.dart';
import 'package:expense_tracker/features/category/domain/entities/categoryModel.dart';
import 'package:expense_tracker/features/category/presenation/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();

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
          Expanded(
            child: ListView.builder(
              itemCount: category.categories.length,
              itemBuilder: (_, i) {
                final c = category.categories[i];
                return Padding(
                  key: ValueKey(c.label),
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: grey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(c.icon, height: 30),
                        SizedBox(width: 15),
                        Text(c.label, style: TextTheme.of(context).bodyLarge,),
                        const Spacer(),
                        if (!c.isDefault)
                          IconButton(
                            onPressed: () {
                              context.read<CategoryProvider>().delete(c.label);
                            },
                            icon: Icon(Icons.delete, color: errorColor),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}

class CategoryFAB extends StatefulWidget {
  const CategoryFAB({super.key});

  @override
  State<CategoryFAB> createState() => _CategoryFABState();
}

class _CategoryFABState extends State<CategoryFAB> {
  final addCategoryController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Color(0xFFFBEFEF),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Add Category'),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  validator: (value) {
                    if (expenseCategoryEntity.any(
                      (e) =>
                          e['label']!.toLowerCase() ==
                          addCategoryController.text.toLowerCase(),
                    )) {
                      return 'category is already exist!';
                    } else if (value!.length > 25) {
                      return 'Maximum 25 Character Allowed!';
                    } else if (value.trim().contains(' ')) {
                      return 'Only One word allowed';
                    }
                    return null;
                  },
                  controller: addCategoryController,
                  autofocus: true,
                  decoration: InputDecoration(label: Text('Category Name')),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),

                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<CategoryProvider>().add(
                        addCategoryController.text,
                      );

                      Navigator.pop(context);


                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                      });
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
      icon: Icon(Icons.add, color: Colors.black),
      label: Text('Add Category', style: TextStyle(color: Colors.black)),
    );
  }
}
