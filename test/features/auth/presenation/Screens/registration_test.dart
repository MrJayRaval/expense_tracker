import 'package:expense_tracker/features/auth/presentation/provider/auth_provider.dart';
import 'package:expense_tracker/features/auth/presentation/screen/registration_page.dart';
import 'package:expense_tracker/features/auth/features/create_profile/presentation/provider/profile_provider.dart';
import 'package:expense_tracker/features/auth/features/create_profile/data/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

class MockProfileProvider extends Mock implements ProfileProvider {}

Widget createWidgetUnderTest(
  AuthProvider provider,
  ProfileProvider profileProvider,
) {
  return MaterialApp(
    home: MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: provider),
        ChangeNotifierProvider<ProfileProvider>.value(
          value: profileProvider,
        ), // Fixed: use ChangeNotifierProvider if ProfileProvider is ChangeNotifier
      ],
      child: RegistrationPage(),
    ),
  );
}

void main() {
  late MockAuthProvider mockAuth;
  late MockProfileProvider mockProfile;

  setUpAll(() {
    registerFallbackValue(
      UserProfileModel(uid: 'uid', name: 'name', email: 'email'),
    );
  });

  setUp(() {
    mockAuth = MockAuthProvider();
    mockProfile = MockProfileProvider();

    when(() => mockAuth.error).thenReturn(null);
    when(() => mockAuth.register(any(), any())).thenAnswer((_) async => true);
    when(() => mockAuth.isLoading).thenReturn(false);
    when(() => mockProfile.isLoading).thenReturn(false);
    when(() => mockProfile.error).thenReturn(null);
    when(() => mockProfile.createProfile(any())).thenAnswer((_) async => true);
  });

  testWidgets('Registration page renders all required widgets', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest(mockAuth, mockProfile));

    expect(find.text('Nice to meet you!'), findsOneWidget);
    expect(find.byType(TextFormField), findsAtLeastNWidgets(4));
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('Shows validation error in Registration Page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest(mockAuth, mockProfile));

    // Wait for the widgets to settle
    await tester.pumpAndSettle();

    // Ensure 'Sign Up' button is visible before tapping
    final signUpFinder = find.text('Sign Up');
    await tester.ensureVisible(signUpFinder);
    await tester.tap(signUpFinder);
    await tester.pumpAndSettle();

    expect(find.text('Enter Username'), findsOneWidget);
    expect(find.text('Enter Email'), findsOneWidget);
    expect(find.text('Enter Password'), findsOneWidget);
    expect(find.text('Enter Confirm Password'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(1), 'ABC');
    await tester.ensureVisible(signUpFinder);
    await tester.tap(signUpFinder);
    await tester.pumpAndSettle();
    expect(find.text('Enter valid email'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'ABC');
    await tester.enterText(find.byType(TextFormField).at(1), 'abc@gmail.com');
    await tester.enterText(find.byType(TextFormField).at(2), '123456');
    await tester.enterText(find.byType(TextFormField).at(3), '123456');
    await tester.tap(signUpFinder);
    await tester.pump();
  });

  testWidgets('Shows dialog when registration fails', (
    WidgetTester tester,
  ) async {
    when(() => mockAuth.register(any(), any())).thenAnswer((_) async => false);
    when(() => mockAuth.error).thenReturn('Unable to sign up.');

    await tester.pumpWidget(createWidgetUnderTest(mockAuth, mockProfile));
    await tester.pumpAndSettle();

    final signUpFinder = find.text('Sign Up');

    await tester.enterText(find.byType(TextFormField).at(0), 'ABC');
    await tester.enterText(find.byType(TextFormField).at(1), 'abc@gmail.com');
    await tester.enterText(find.byType(TextFormField).at(2), '123456');
    await tester.enterText(find.byType(TextFormField).at(3), '123456');

    await tester.ensureVisible(signUpFinder);
    await tester.tap(signUpFinder);
    await tester.pumpAndSettle();

    expect(find.text('Sign Up Failed'), findsOneWidget);
    expect(find.text('Unable to sign up.'), findsOneWidget);
  });
}
