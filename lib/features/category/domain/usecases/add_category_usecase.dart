import 'package:expense_tracker/features/category/domain/repository/category_repository.dart';

class AddCategoryUsecase {
  final CategoryRepository repository;

  AddCategoryUsecase(this.repository);

  Future<void> addCategory(String label) {
    return repository.addCategory(label);
  }
}
