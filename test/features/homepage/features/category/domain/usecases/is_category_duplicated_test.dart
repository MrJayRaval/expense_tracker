import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:expense_tracker/features/homepage/features/category/domain/repository/category_repository.dart';
import 'package:expense_tracker/features/homepage/features/category/domain/usecases/is_category_duplicated.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  late IsCategoryDuplicatedUseCase usecase;
  late MockCategoryRepository mockRepository;

  setUp(() {
    mockRepository = MockCategoryRepository();
    usecase = IsCategoryDuplicatedUseCase(
      repository: mockRepository,
    ); // Uses named parameter
  });

  test('should return true if category exists', () async {
    const tLabel = 'Food';
    when(
      () => mockRepository.isCategoryDuplicated(any()),
    ).thenAnswer((_) async => true);

    final result = await usecase.isCategoryDuplicated(tLabel);

    expect(result, true);
    verify(() => mockRepository.isCategoryDuplicated(tLabel)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
