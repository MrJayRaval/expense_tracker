import 'package:expense_tracker/features/category/domain/repository/category_repository.dart';

class IsCategoryDuplicatedUseCase {
  final CategoryRepository repository;

  IsCategoryDuplicatedUseCase({required this.repository});

  Future<bool> isCategoryDuplicated(String label) async {
    return repository.isCategoryDuplicated(label);
  }
}
