import '../entities/category_model.dart';
import '../repository/category_repository.dart';

class GetCategoryUsecase {
  final CategoryRepository repository;

  GetCategoryUsecase(this.repository);

  Future<List<CategoryModel>> getCategory() async {
    return repository.getAllCategories();
  }
}
