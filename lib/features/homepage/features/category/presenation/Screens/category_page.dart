import '../../../../../../config/theme_helper.dart';
import '../providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with AutomaticKeepAliveClientMixin {
  late final Map<String, Widget> _svgCache = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().load();
    });

  }

  Widget _cachedSvgIcon(String iconPath, double height, Color color) {
    final key = '$iconPath-$height-${color.value}';
    _svgCache.putIfAbsent(
      key,
      () => SvgPicture.asset(iconPath, height: height, color: color),
    );
    return _svgCache[key]!;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final category = context.watch<CategoryProvider>();

    if (category.isLoading && category.categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: category.categories.length,
              itemBuilder: (_, i) {
                final c = category.categories[i];
                final inverseSurfaceColor = Theme.of(
                  context,
                ).colorScheme.inverseSurface;
                final surfaceBrightColor = Theme.of(
                  context,
                ).colorScheme.surfaceBright;
                final outlineColor = ThemeHelper.outline;
                final onSurfaceColor = ThemeHelper.onSurface;
                final errorColor = ThemeHelper.error;
            
                return Padding(
                  key: ValueKey(c.label),
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ThemeHelper.primaryContainer,
                      
                      border: Border.all(color: outlineColor),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              bottomLeft: Radius.circular(6),
                            ),
                            color: inverseSurfaceColor,
                          ),
                          child: _cachedSvgIcon(c.icon, 30, surfaceBrightColor),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            c.label,
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(color: onSurfaceColor),
                          ),
                        ),
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _svgCache.clear();
    super.dispose();
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

  @override
  void dispose() {
    addCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: ThemeHelper.surface,
      onPressed: () => _showAddCategoryDialog(),
      icon: Icon(Icons.add, color: ThemeHelper.onSurface),
      label: Text(
        'Add Category',
        style: TextStyle(color: ThemeHelper.onSurface),
      ),
    );
  }

  void _showAddCategoryDialog() {
    addCategoryController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Category name required';
                }
                final provider = context.read<CategoryProvider>();
                provider.load();
                if (provider.categories.any(
                  (c) => c.label.toLowerCase() == value.toLowerCase(),
                )) {
                  return 'Category already exists!';
                }
                if (value.length > 25) {
                  return 'Maximum 25 characters allowed!';
                }
                if (value.trim().contains(' ')) {
                  return 'Only one word allowed';
                }
                return null;
              },
              controller: addCategoryController,
              // autofocus: true,
              decoration: const InputDecoration(label: Text('Category Name')),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => _addCategory(context),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addCategory(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<CategoryProvider>().add(addCategoryController.text);
      Navigator.pop(context);
      addCategoryController.clear();
    }
  }
}
