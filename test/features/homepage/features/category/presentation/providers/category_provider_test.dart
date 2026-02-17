import 'package:expense_tracker/features/homepage/features/category/domain/entities/category_model.dart';
import 'package:expense_tracker/features/homepage/features/category/domain/usecases/add_category_usecase.dart';
import 'package:expense_tracker/features/homepage/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:expense_tracker/features/homepage/features/category/domain/usecases/get_category_usecase.dart';
import 'package:expense_tracker/features/homepage/features/category/domain/usecases/is_category_duplicated.dart';
import 'package:expense_tracker/features/homepage/features/category/presenation/providers/category_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddCategoryUsecase extends Mock implements AddCategoryUsecase {}

class MockGetCategoryUsecase extends Mock implements GetCategoryUsecase {}

class MockDeleteCategoryUsecase extends Mock implements DeleteCategoryUsecase {}

class MockIsCategoryDuplicatedUseCase extends Mock
    implements IsCategoryDuplicatedUseCase {}

void main() {
  late CategoryProvider provider;
  late MockAddCategoryUsecase mockAdd;
  late MockGetCategoryUsecase mockGet;
  late MockDeleteCategoryUsecase mockDelete;
  late MockIsCategoryDuplicatedUseCase mockIsDuplicated;

  setUp(() {
    mockAdd = MockAddCategoryUsecase();
    mockGet = MockGetCategoryUsecase();
    mockDelete = MockDeleteCategoryUsecase();
    mockIsDuplicated = MockIsCategoryDuplicatedUseCase();

    provider = CategoryProvider(
      addCategoryUsecase: mockAdd,
      getCategoryUsecase: mockGet,
      deleteCategoryUsecase: mockDelete,
      isCategoryDuplicatedUseCase: mockIsDuplicated,
    );
  });

  test('load should update categories from usecase', () async {
    final tCategories = [
      CategoryModel(label: 'Food', icon: 'icon', isDefault: true),
    ];
    when(() => mockGet.getCategory()).thenAnswer((_) async => tCategories);

    await provider.load();

    expect(provider.categories, tCategories);
    expect(provider.isLoading, false);
    verify(() => mockGet.getCategory()).called(1);
  });

  test('add should add category and call usecase', () async {
    const tLabel = 'NewCategory';
    when(() => mockAdd.addCategory(any())).thenAnswer((_) async => {});

    await provider.add(tLabel);

    expect(provider.categories.any((c) => c.label == tLabel), true);
    verify(() => mockAdd.addCategory(tLabel)).called(1);
  });

  test('delete should remove category and call usecase', () async {
    const tLabel = 'Food';
    provider.categories = [
      CategoryModel(label: tLabel, icon: 'icon', isDefault: true),
    ];
    when(() => mockDelete.deleteCategory(any())).thenAnswer((_) async => {});

    await provider.delete(tLabel);

    expect(provider.categories.any((c) => c.label == tLabel), false);
    verify(() => mockDelete.deleteCategory(tLabel)).called(1);
  });

  test('isCategoryDuplicated should call usecase', () async {
    const tLabel = 'Food';
    when(
      () => mockIsDuplicated.isCategoryDuplicated(any()),
    ).thenAnswer((_) async => true);

    final result = await provider.isCategoryDuplicated(tLabel);

    expect(result, true);
    verify(() => mockIsDuplicated.isCategoryDuplicated(tLabel)).called(1);
  });
}
