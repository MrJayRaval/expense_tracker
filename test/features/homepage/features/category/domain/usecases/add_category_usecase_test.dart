import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:expense_tracker/features/homepage/features/category/domain/repository/category_repository.dart';
import 'package:expense_tracker/features/homepage/features/category/domain/usecases/add_category_usecase.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  late AddCategoryUsecase usecase;
  late MockCategoryRepository mockRepository;

  setUp(() {
    mockRepository = MockCategoryRepository();
    usecase = AddCategoryUsecase(mockRepository);
  });

  test('should call addCategory from repository', () async {
    const tLabel = 'Food';
    when(() => mockRepository.addCategory(any())).thenAnswer((_) async => {});

    await usecase.addCategory(tLabel);

    verify(() => mockRepository.addCategory(tLabel)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
