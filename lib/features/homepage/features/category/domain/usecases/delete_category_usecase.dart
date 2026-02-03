import '../repository/category_repository.dart';

class DeleteCategoryUsecase {
  final CategoryRepository repository;

  DeleteCategoryUsecase(this.repository);

  Future<void> deleteCategory(String label) {
    return repository.deleteCategory(label);
  }
}
