import 'package:expense_tracker/features/category/domain/entities/category_model.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> getAllCategories();
  Future<void> addCategory(String label);
  Future<void> deleteCategory(String label);
  Future<bool> isCategoryDuplicated(String label);
}
