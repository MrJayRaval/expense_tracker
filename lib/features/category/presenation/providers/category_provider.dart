import 'package:expense_tracker/features/category/domain/entities/category_model.dart';
import 'package:expense_tracker/features/category/domain/usecases/add_category_usecase.dart';
import 'package:expense_tracker/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:expense_tracker/features/category/domain/usecases/get_category_usecase.dart';
import 'package:expense_tracker/features/category/domain/usecases/is_category_duplicated.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  final AddCategoryUsecase addCategoryUsecase;
  final GetCategoryUsecase getCategoryUsecase;
  final DeleteCategoryUsecase deleteCategoryUsecase;
  final IsCategoryDuplicatedUseCase isCategoryDuplicatedUseCase;

  List<CategoryModel> categories = [];
  bool isLoading = false;

  CategoryProvider({
    required this.addCategoryUsecase,
    required this.getCategoryUsecase,
    required this.deleteCategoryUsecase, 
    required this.isCategoryDuplicatedUseCase,
  });

  Future<void> load() async {
    isLoading = true;

    categories = await getCategoryUsecase.getCategory();

    isLoading = false;
    notifyListeners();
  }

  Future<void> add(String label) async {
    isLoading = true;

    final newCategory = CategoryModel(
      label: label,
      isDefault: false,
      icon: 'assets/Images/categoryIcon/custom.svg',
    );

    categories.add(newCategory);

    isLoading = false;
    notifyListeners();

    await addCategoryUsecase.addCategory(label);
  }

  Future<void> delete(String label) async {
    isLoading = true;
    await deleteCategoryUsecase.deleteCategory(label);

    categories = await getCategoryUsecase.getCategory();
    isLoading = false;
    notifyListeners();
  }

  Future<bool> isCategoryDuplicated(String label) async {
    isLoading = true;
    final check = await isCategoryDuplicatedUseCase.isCategoryDuplicated(label);
    isLoading = false;
    notifyListeners();

    return check;
  }
}
