import 'package:expense_tracker/config/theme_helper.dart';
import 'package:expense_tracker/features/homepage/features/category/presenation/providers/category_provider.dart';
import 'package:expense_tracker/ui/components/cached_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryListWidget<T extends CategoryProvider> extends StatefulWidget {
  final String title;
  final bool useOriginalColor;

  const CategoryListWidget({
    super.key,
    required this.title,
    this.useOriginalColor = false,
  });

  @override
  State<CategoryListWidget<T>> createState() => _CategoryListWidgetState<T>();
}

class _CategoryListWidgetState<T extends CategoryProvider>
    extends State<CategoryListWidget<T>> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<T>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.surface,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ThemeHelper.onSurface,
        onPressed: () => _showAddSheet(context),
        icon: Icon(Icons.add, color: ThemeHelper.surface),
        label: Text(
          'Add ${widget.title}',
          style: TextStyle(
            color: ThemeHelper.surface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<T>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 64,
                    color: ThemeHelper.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No ${widget.title} found',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ThemeHelper.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 100, top: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: provider.categories.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final item = provider.categories[i];
              return Dismissible(
                key: Key(item.label),
                direction: item.isDefault
                    ? DismissDirection.none
                    : DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: ThemeHelper.errorContainer,
                  child: Icon(
                    Icons.delete,
                    color: ThemeHelper.onErrorContainer,
                  ),
                ),
                confirmDismiss: (direction) async {
                  // Optional confirmation dialog
                  return true;
                },
                onDismissed: (direction) {
                  provider.delete(item.label);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item.label} deleted')),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: ThemeHelper.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: ThemeHelper.outline.withValues(alpha: 0.5),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ThemeHelper.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CachedSvgIcon(
                        iconPath: item.icon,
                        height: 24,
                        color: widget.useOriginalColor
                            ? null
                            :  ThemeHelper.onSecondaryContainer,
                      ),
                    ),
                    title: Text(
                      item.label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ThemeHelper.onSurface,
                      ),
                    ),
                    trailing: item.isDefault
                        ? Icon(
                            Icons.lock_outline,
                            size: 18,
                            color: ThemeHelper.outline,
                          )
                        : Icon(Icons.drag_handle, color: ThemeHelper.outline),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeHelper.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add New ${widget.title}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ThemeHelper.onSurface,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.label_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    if (value.length > 20) return 'Too long';
                    // Check duplicate
                    // Access provider outside build context carefully
                    // Here straightforward via read
                    // But duplicates check is async in provider.
                    // Simple check against current list:
                    final provider = context.read<T>();
                    if (provider.categories.any(
                      (e) => e.label.toLowerCase() == value.toLowerCase(),
                    )) {
                      return 'Already exists';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<T>().add(controller.text.trim());
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
