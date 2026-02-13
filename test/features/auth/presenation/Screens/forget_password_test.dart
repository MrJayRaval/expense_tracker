import 'package:expense_tracker/config/theme_helper.dart';
import 'package:expense_tracker/features/auth/domain/usecases/reset_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:expense_tracker/features/auth/presentation/provider/auth_provider.dart';
import 'package:expense_tracker/features/auth/presentation/screen/forget_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

class MockResetPasswordUsecase extends Mock implements ResetPasswordUseCase {}

class MockSignInUsecase extends Mock implements SignInUseCase {}

class MockSignUpUsecase extends Mock implements SignUpUseCase {}

final authProvider = AuthProvider(
  signUp: MockSignUpUsecase(),
  signIn: MockSignInUsecase(),
  resetPassword: MockResetPasswordUsecase(),
);

Widget createWidgetUnderTest(AuthProvider provider) {
  return MaterialApp(
    builder: (context, child) {
      ThemeHelper.init(context);
      return child!;
    },
    home: ChangeNotifierProvider<AuthProvider>.value(
      value: provider,
      child: const ForgotPassword(),
    ),
  );
}

void main() {
  late MockResetPasswordUsecase mockResetPassword;
  late MockSignInUsecase mockSignIn;
  late MockSignUpUsecase mockSignUp;
  late AuthProvider authProvider;

  setUp(() {
    mockResetPassword = MockResetPasswordUsecase();
    mockSignIn = MockSignInUsecase();
    mockSignUp = MockSignUpUsecase();

    when(
      () => mockResetPassword(any()),
    ).thenAnswer((_) async {}); // RETURNS Future<void>

    authProvider = AuthProvider(
      signUp: mockSignUp,
      signIn: mockSignIn,
      resetPassword: mockResetPassword,
    );
  });

  testWidgets('Forget Password page shold render all required widgets', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest(authProvider));
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.byType(TextFormField), findsAtLeastNWidgets(1));
    expect(find.text('Send'), findsOneWidget);
    expect(find.text('Back to Log In'), findsOneWidget);
  });

  testWidgets('Shows Validation errors', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(authProvider));
    await tester.ensureVisible(find.text('Send'));
    await tester.tap(find.text('Send'));
    await tester.pump();

    expect(find.text('Enter Email'), findsOneWidget);
  });

  testWidgets(
    'Should call resetPasswordLink on AuthProvider when tap on Send button',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(authProvider));
      await tester.enterText(find.byType(TextFormField).at(0), 'abc@gmail.com');
      await tester.ensureVisible(find.text('Send'));
      await tester.tap(find.text('Send'));
      await tester.pump();

      verify(() => authProvider.resetPasswordLink(any())).called(1);
    },
  );
}
