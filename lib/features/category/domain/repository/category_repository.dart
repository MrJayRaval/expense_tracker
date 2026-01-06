import 'package:expense_tracker/features/category/domain/entities/categoryModel.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> getAllCategories();
  Future<void> addCategory(String label);
  Future<void> deleteCategory(String label);
}
