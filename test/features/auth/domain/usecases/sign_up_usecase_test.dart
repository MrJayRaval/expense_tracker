import '../../../../../linux/lib/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'sign_in_usecase_test.dart';

void main() {
  late MockAuthRepository mockRepository;
  late SignUpUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignUpUseCase(mockRepository);
  });

  test(
    'Should call signUp on AuthRepository with correct Email and password',
    () async {
      const email = 'abc@example.com';
      const password = 'Example@123';

      when(
        () => mockRepository.signUp(email, password),
      ).thenAnswer((_) async {});

      // act
      await useCase(email, password);

      // assert
      verify(() => mockRepository.signUp(email, password)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
