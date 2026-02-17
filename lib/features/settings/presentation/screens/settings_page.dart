import 'package:expense_tracker/config/theme_helper.dart';
import 'package:expense_tracker/ui/components/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Card(
                  elevation: 0,
                  color: ThemeHelper.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: Text(
                          'Dark Mode',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: ThemeHelper.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        subtitle: Text(
                          themeProvider.isDarkMode
                              ? 'Switch to Light Mode'
                              : 'Switch to Dark Mode',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: ThemeHelper.onSurfaceVariant),
                        ),
                        secondary: Icon(
                          themeProvider.isDarkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: ThemeHelper.primary,
                        ),
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme();
                        },
                      ),
                      const Divider(),
                      SwitchListTile(
                        title: Text(
                          'Animations',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: ThemeHelper.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        subtitle: Text(
                          themeProvider.isAnimationsEnabled
                              ? 'Enable animations'
                              : 'Disable animations',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: ThemeHelper.onSurfaceVariant),
                        ),
                        secondary: Icon(
                          Icons.animation,
                          color: ThemeHelper.primary,
                        ),
                        value: themeProvider.isAnimationsEnabled,
                        onChanged: (value) {
                          themeProvider.toggleAnimations(value);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
