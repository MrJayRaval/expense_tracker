import 'package:expense_tracker/features/homepage/features/category/domain/entities/category_model.dart';
import 'package:expense_tracker/features/homepage/features/transaction/domain/entity/transaction_category_model.dart';
import 'package:expense_tracker/features/homepage/features/transaction/domain/entity/transaction_source_model.dart';

List<CategoryModel> get defaultExpenseCategories => defaultCategoryModels;

List<CategoryModel> get defaultIncomeCategories => incomeSourceModel.map((e) {
  return CategoryModel(label: e['label']!, icon: e['icon']!, isDefault: true);
}).toList();

List<CategoryModel> get defaultSourceCategories => transactionCategoryModel.map(
  (e) {
    return CategoryModel(label: e['label']!, icon: e['icon']!, isDefault: true);
  },
).toList();
