import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:expense_tracker/features/homepage/features/category/domain/repository/category_repository.dart';
import 'package:expense_tracker/features/homepage/features/category/domain/usecases/delete_category_usecase.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  late DeleteCategoryUsecase usecase;
  late MockCategoryRepository mockRepository;

  setUp(() {
    mockRepository = MockCategoryRepository();
    usecase = DeleteCategoryUsecase(mockRepository);
  });

  test('should call deleteCategory from repository', () async {
    const tLabel = 'Food';
    when(
      () => mockRepository.deleteCategory(any()),
    ).thenAnswer((_) async => {});

    await usecase.deleteCategory(tLabel);

    verify(() => mockRepository.deleteCategory(tLabel)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
