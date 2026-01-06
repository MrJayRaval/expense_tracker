import 'package:expense_tracker/features/category/domain/entities/categoryModel.dart';
import 'package:expense_tracker/features/category/domain/repository/category_repository.dart';

class GetCategoryUsecase {
  final CategoryRepository repository;

  GetCategoryUsecase(this.repository);

  Future<List<CategoryModel>> getCategory() async {
    return repository.getAllCategories();
  }
}
