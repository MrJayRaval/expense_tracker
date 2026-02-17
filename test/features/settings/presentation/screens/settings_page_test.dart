import 'package:expense_tracker/features/settings/presentation/screens/settings_page.dart';
import 'package:expense_tracker/ui/components/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class MockThemeProvider extends ChangeNotifier implements ThemeProvider {
  @override
  bool get isDarkMode => false;

  @override
  ThemeMode get themeMode => ThemeMode.light;

  @override
  bool get isAnimationsEnabled => true;

  @override
  void toggleTheme() {
    notifyListeners();
  }

  @override
  Future<void> toggleAnimations(bool value) async {
    notifyListeners();
  }

  @override
  void setDark() {}

  @override
  void setLight() {}
}

void main() {
  testWidgets('SettingsPage renders correctly', (WidgetTester tester) async {
    final mockTheme = MockThemeProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<ThemeProvider>.value(
        value: mockTheme,
        child: const MaterialApp(home: SettingsPage()),
      ),
    );

    expect(find.text('Dark Mode'), findsOneWidget);
    expect(find.text('Switch to Dark Mode'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsNWidgets(2));
  });
}
