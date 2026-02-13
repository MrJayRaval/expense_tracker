import 'package:hive_flutter/adapters.dart';

// category_local_datasource.dart
class CategoryLocalDatasource {
  static const _box = 'expenseCategory';

  Future<void> cacheCategories(List<String> labels) async {
    final box =  Hive.box(_box);
    await box.put('list', labels);
  }

  Future<List<String>> getCachedCategories() async {
    final box = Hive.box(_box);
    return List<String>.from(box.get('list') ?? []);
  }

  Future<void> deleteCachedCategory(String label) async {
    final box = Hive.box(_box);
    List<String> items = List<String>.from(box.get('list') ?? []);

    items.remove(label);

    await box.put('list', items);
  }
}
