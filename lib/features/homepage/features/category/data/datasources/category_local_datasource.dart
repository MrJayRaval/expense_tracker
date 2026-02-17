import 'package:hive_flutter/adapters.dart';

// category_local_datasource.dart
class CategoryLocalDatasource {
  final String boxName;

  CategoryLocalDatasource(this.boxName);

  Future<void> cacheCategories(List<String> labels) async {
    final box = Hive.box(boxName);
    await box.put('list', labels);
  }

  Future<List<String>> getCachedCategories() async {
    final box = Hive.box(boxName);
    return List<String>.from(box.get('list') ?? []);
  }

  Future<void> deleteCachedCategory(String label) async {
    final box = Hive.box(boxName);
    List<String> items = List<String>.from(box.get('list') ?? []);

    items.remove(label);

    await box.put('list', items);
  }
}
