import 'package:expense_tracker/features/auth/domain/usecases/reset_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:expense_tracker/features/auth/presentation/provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignInUseCase extends Mock implements SignInUseCase {}

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

void main() {
  late MockSignInUseCase mockSignInUseCase;
  late MockSignUpUseCase mockSignUpUseCase;
  late MockResetPasswordUseCase mockResetPasswordUseCase;
  late AuthProvider provider;

  setUp(() {
    mockSignInUseCase = MockSignInUseCase();
    mockSignUpUseCase = MockSignUpUseCase();
    mockResetPasswordUseCase = MockResetPasswordUseCase();
    provider = AuthProvider(
      signUp: mockSignUpUseCase,
      signIn: mockSignInUseCase,
      resetPassword: mockResetPasswordUseCase,
    );
  });

  // ======================================================================================
  // logIn:

  test(
    'when Login success then clear errors and update loading state',
    () async {
      const email = 'testt@example.com';
      const password = 'password';

      // arrangement
      when(() => mockSignInUseCase(email, password)).thenAnswer((_) async {});
      final states = <bool>[];
      provider.addListener(() {
        states.add(provider.isLoading);
      });

      // Act
      final result = await provider.logIn(email, password);

      // Assert
      expect(result, true);
      expect(states, [true, false]);
      expect(provider.error, null);

      verify(() => mockSignInUseCase(email, password)).called(1);
    },
  );

  test('should throws exception when logIn of provider fails', () async {
    when(() => mockSignInUseCase(any(), any())).thenThrow(
      FirebaseAuthException(code: 'wrong-password', message: 'bad password'),
    );

    final states = <bool>[];
    provider.addListener(() {
      states.add(provider.isLoading);
    });

    // act
    final result = await provider.logIn('a', 'b');

    expect(result, false);
    expect(states, [true, false]);
    expect(provider.error, isNotNull);
    expect(provider.error, 'Invalid email or password.');
  });

  // =======================================================================================
  // register:

  test('when register called, should updates state and clear error', () async {
    const email = 'abc@email.com';
    const password = 'Exapmle.com';

    when(() => mockSignUpUseCase(email, password)).thenAnswer((_) async {});

    final states = <bool>[];
    provider.addListener(() {
      states.add(provider.isLoading);
    });

    // act
    final result = await provider.register(email, password);

    // assert
    expect(result, true);
    expect(states, [true, false]);
    expect(provider.error, null);
  });

  test('should throw exception when register on provider fails', () async {
    when(
      () => mockSignUpUseCase(any(), any()),
    ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

    final states = <bool>[];
    provider.addListener(() {
      states.add(provider.isLoading);
    });

    // act
    final result = await provider.register('a', 'b');

    // assert
    expect(result, false);
    expect(states, [true, false]);
    expect(provider.error, isNotNull);
    expect(provider.error, 'An account already exists for that email.');
  });

  test('clearError should reset error state', () async {
    when(
      () => mockSignInUseCase(any(), any()),
    ).thenThrow(FirebaseAuthException(code: 'invalid-email'));

    await provider.logIn('a', 'b');
    expect(provider.error, isNotNull);

    provider.clearError();
    expect(provider.error, null);
  });
}
