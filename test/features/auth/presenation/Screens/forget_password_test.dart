import 'package:expense_tracker/features/auth/domain/usecases/reset_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:expense_tracker/features/auth/presentation/pages/forget_password.dart';
import 'package:expense_tracker/features/auth/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockAuthProvider extends Mock implements AuthProviderr {}

class MockResetPasswordUsecase extends Mock implements ResetPasswordUseCase {}

class MockSignInUsecase extends Mock implements SignInUseCase {}

class MockSignUpUsecase extends Mock implements SignUpUseCase {}

final authProvider = AuthProviderr(
  signUp: MockSignUpUsecase(),
  signIn: MockSignInUsecase(),
  resetPassword: MockResetPasswordUsecase(),
);

Widget createWidgetUnderTest(AuthProviderr provider) {
  return MaterialApp(
    home: ChangeNotifierProvider<AuthProviderr>.value(
      value: authProvider,
      child: const MaterialApp(home: ForgotPassword()),
    ),
  );
}

void main() {
  setUp(() {
    final mockResetPassword = MockResetPasswordUsecase();

    when(() => mockResetPassword(any())).thenAnswer((_) async {});

    // ensure the authProvider used by the widget is stubbed as well
    when(() => authProvider.resetPassword(any())).thenAnswer((_) async {});
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
