import '../../../../../linux/lib/features/auth/presentation/screen/registration_page.dart';
import '../../../../../linux/lib/features/auth/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockAuthProvider extends Mock implements AuthProviderr {}

Widget createWidgetUnderTest(AuthProviderr provider) {
  return MaterialApp(
    home: ChangeNotifierProvider<AuthProviderr>.value(
      value: provider,
      child: RegistrationPage(),
    ),
  );
}

void main() {
  late MockAuthProvider mockAuth;

  setUp(() {
    mockAuth = MockAuthProvider();

    when(() => mockAuth.error).thenReturn(null);
    when(() => mockAuth.register(any(), any())).thenAnswer((_) async => true);
    when(() => mockAuth.isLoading).thenReturn(false);
  });

  testWidgets('Registration page renders all required widgets', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest(mockAuth));

    expect(find.text('Nice to meet you!'), findsOneWidget);
    expect(find.byType(TextFormField), findsAtLeastNWidgets(4));
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('Shows validation error in Registration Page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest(mockAuth));

    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Enter Username'), findsOneWidget);
    expect(find.text('Enter Email'), findsOneWidget);
    expect(find.text('Enter Password'), findsOneWidget);
    expect(find.text('Enter Confirm Password'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(1), 'ABC');
    await tester.ensureVisible(find.text('Sign Up'));
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();
    expect(find.text('Enter valid email'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'ABC');
    await tester.enterText(find.byType(TextFormField).at(1), 'abc@gmail.com');
    await tester.enterText(find.byType(TextFormField).at(2), '123456');
    await tester.enterText(find.byType(TextFormField).at(3), '123456');
    await tester.tap(find.text('Sign Up'));
    await tester.pump();
  });
}
