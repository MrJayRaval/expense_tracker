import 'package:expense_tracker/config/theme_helper.dart';
import 'package:expense_tracker/features/auth/presentation/provider/auth_provider.dart';
import 'package:expense_tracker/features/auth/presentation/screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

Widget createWidgetUnderTest(AuthProvider provider) {
  return MaterialApp(
    builder: (context, child) {
      ThemeHelper.init(context);
      return child!;
    },
    routes: {
      '/dashboard': (context) => const SizedBox(),
      '/forgot-password': (context) => const SizedBox(),
      '/register': (context) => const SizedBox(),
    },
    home: ChangeNotifierProvider<AuthProvider>.value(
      builder: (context, child) {
        ThemeHelper.init(context);
        return child!;
      },
      value: provider,
      child: LoginPage(),
    ),
  );
}

void main() {
  late MockAuthProvider mockAuth;

  setUp(() {
    mockAuth = MockAuthProvider();

    when(() => mockAuth.isLoading).thenReturn(false);
    when(() => mockAuth.error).thenReturn(null);
    when(() => mockAuth.logIn(any(), any())).thenAnswer((_) async => true);
  });

  testWidgets('login page renders all required widgets', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest(mockAuth));

    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.byType(TextFormField), findsAtLeastNWidgets(2));
  });

  testWidgets('Shows validation errors when fields are empty', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest(mockAuth));
    await tester.tap(find.text('Sign In'));
    await tester.pump();

    expect(find.text('Enter Email'), findsOneWidget);
    expect(find.text('Enter Username'), findsOneWidget);
  });

  testWidgets('calls login when valid data is entered', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest(mockAuth));

    await tester.enterText(find.byType(TextFormField).at(0), 'abc@gmail.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'Example@123');

    await tester.tap(find.text('Sign In'));
    await tester.pump();

    verify(() => mockAuth.logIn(any(), any())).called(1);
  });

  testWidgets('shows dialog when login fails', (WidgetTester tester) async {
    when(() => mockAuth.logIn(any(), any())).thenAnswer((_) async => false);
    when(() => mockAuth.error).thenReturn('Invalid email or password.');

    await tester.pumpWidget(createWidgetUnderTest(mockAuth));

    await tester.enterText(find.byType(TextFormField).at(0), 'abc@gmail.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'wrongpass');

    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Sign In Failed'), findsOneWidget);
    expect(find.text('Invalid email or password.'), findsOneWidget);
  });

  testWidgets('does not show dialog when login succeeds', (
    WidgetTester tester,
  ) async {
    when(() => mockAuth.logIn(any(), any())).thenAnswer((_) async => true);
    when(() => mockAuth.error).thenReturn(null);

    await tester.pumpWidget(createWidgetUnderTest(mockAuth));

    await tester.enterText(find.byType(TextFormField).at(0), 'abc@gmail.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'Example@123');

    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Sign In Failed'), findsNothing);
  });
}
