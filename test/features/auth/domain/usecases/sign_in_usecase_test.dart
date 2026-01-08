import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignInUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignInUseCase(mockRepository);
  });

  test(
    'Should call signIn on AuthRepository with correct email and password',
    () async {
      // arrange
      const email = 'abc@example.com';
      const password = 'Example@123';

      when(
        () => mockRepository.signIn(email, password),
      ).thenAnswer((_) async {});

      // act
      await useCase(email, password);

      // assert
      verify(() => mockRepository.signIn(email, password)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'Should throw exception when signIn UseCase of AuthRepository fails ',
    () async {
      // arrange
      const email = 'abc@example.com';
      const password = 'Example@123';

      when(
        () => mockRepository.signIn(email, password),
      ).thenThrow(Exception('User Already Exist'));

      expectLater(() => useCase(email, password), throwsA(isA<Exception>()));
    },
  );
}
