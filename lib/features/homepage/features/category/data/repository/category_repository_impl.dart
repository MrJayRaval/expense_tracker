import 'dart:async';

import '../datasources/category_local_datasource.dart';
import '../datasources/category_remote_datasource.dart';
import '../../domain/entities/category_model.dart';
import '../../domain/repository/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDatasource local;
  final CategoryRemoteDatasource remote;

  CategoryRepositoryImpl({required this.local, required this.remote});

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    // Load Cached Custom Categories
    List<String> customLabel = await local.getCachedCategories();

    // Fetch From firebase if cache is empty
    if (customLabel.isEmpty) {
      customLabel = await remote.fetchCategories();
      await local.cacheCategories(customLabel);
    }

    // convert cutom label to model
    final customModel = customLabel.map((label) {
      return CategoryModel(
        label: label,
        isDefault: false,
        icon: 'assets/Images/categoryIcon/custom.svg',
      );
    }).toList();

    // Merge default + custom
    return [...defaultCategoryModels, ...customModel];
  }

  @override
  Future<void> addCategory(String label) async {
    remote.addCategory(label);

    final cached = await local.getCachedCategories();
    cached.add(label);
    await local.cacheCategories(cached);
  }

  @override
  Future<void> deleteCategory(String label) async {
    await local.deleteCachedCategory(label);

    // Fire-and-forget remote sync for successful UI Update
    remote.deleteCategory(label);
  }
  
  @override
  Future<bool> isCategoryDuplicated(String label) {
    return remote.isCategoryDuplicated(label);
  }
}
