import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:expense_tracker/features/homepage/features/category/domain/entities/category_model.dart';
import 'package:expense_tracker/features/homepage/features/category/domain/repository/category_repository.dart';
import 'package:expense_tracker/features/homepage/features/category/domain/usecases/get_category_usecase.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  late GetCategoryUsecase usecase;
  late MockCategoryRepository mockRepository;

  setUp(() {
    mockRepository = MockCategoryRepository();
    usecase = GetCategoryUsecase(mockRepository);
  });

  test('should return list of categories from repository', () async {
    final tCategories = [
      CategoryModel(label: 'Food', icon: 'food', isDefault: true),
      CategoryModel(label: 'Travel', icon: 'travel', isDefault: false),
    ];
    when(
      () => mockRepository.getAllCategories(),
    ).thenAnswer((_) async => tCategories);

    final result = await usecase.getCategory();

    expect(result, tCategories);
    verify(() => mockRepository.getAllCategories()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
