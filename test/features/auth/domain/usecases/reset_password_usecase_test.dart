import 'package:expense_tracker/features/auth/domain/usecases/reset_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'sign_in_usecase_test.dart';

void main() {
  late MockAuthRepository mockRepository;
  late ResetPasswordUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = ResetPasswordUseCase(mockRepository);
  });

  test(
    'Should call resetPassword on AuthRepository with correct email',
    () async {
      const email = 'abc@example.com';

      when(() => mockRepository.resetPassword(email)).thenAnswer((_) async {});

      // act
      useCase(email);

      // assert
      verify(() => mockRepository.resetPassword(email)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'Should throw exception when resetPasswordUseCase of AuthRepository fails',
    () async {
      const email = 'example123@gmail.com';

      when(
        () => mockRepository.resetPassword(email),
      ).thenThrow(Exception('User not existed'));

      expectLater(() => useCase(email), throwsA(isA<Exception>()));
    },
  );
}
