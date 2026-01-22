import 'package:flutter/material.dart';

/// Theme Helper for caching color scheme to reduce Theme.of() calls
/// This improves performance on low-end devices by avoiding widget tree traversals
class ThemeHelper {
  static late ColorScheme _colorScheme;
  static late TextTheme _textTheme;

  /// Initialize theme colors - call this once in your app startup
  static void init(BuildContext context) {
    _colorScheme = Theme.of(context).colorScheme;
    _textTheme = Theme.of(context).textTheme;
  }

  // Color Scheme Accessors
  static Color get primary => _colorScheme.primary;
  static Color get onPrimary => _colorScheme.onPrimary;
  static Color get secondary => _colorScheme.secondary;
  static Color get onSecondary => _colorScheme.onSecondary;
  static Color get tertiary => _colorScheme.tertiary;
  static Color get onTertiary => _colorScheme.onTertiary;
  static Color get error => _colorScheme.error;
  static Color get onError => _colorScheme.onError;
  static Color get errorContainer => _colorScheme.errorContainer;
  static Color get onErrorContainer => _colorScheme.onErrorContainer;
  static Color get surface => _colorScheme.surface;
  static Color get onSurface => _colorScheme.onSurface;
  static Color get outline => _colorScheme.outline;
  static Color get outlineVariant => _colorScheme.outlineVariant;
  static Color get inverseSurface => _colorScheme.inverseSurface;
  static Color get surfaceVariant => _colorScheme.surfaceContainerHighest;
  static Color get onSurfaceVariant => _colorScheme.onSurfaceVariant;
  static Color get surfaceContainerHighest =>
      _colorScheme.surfaceContainerHighest;
  static Color get surfaceBright => _colorScheme.surfaceBright;
  static Color get surfaceDim => _colorScheme.surfaceDim;
  static Color get scrim => _colorScheme.scrim;

  // Text Theme Accessors
  static TextStyle? get displayLarge => _textTheme.displayLarge;
  static TextStyle? get displayMedium => _textTheme.displayMedium;
  static TextStyle? get displaySmall => _textTheme.displaySmall;
  static TextStyle? get headlineLarge => _textTheme.headlineLarge;
  static TextStyle? get headlineMedium => _textTheme.headlineMedium;
  static TextStyle? get headlineSmall => _textTheme.headlineSmall;
  static TextStyle? get titleLarge => _textTheme.titleLarge;
  static TextStyle? get titleMedium => _textTheme.titleMedium;
  static TextStyle? get titleSmall => _textTheme.titleSmall;
  static TextStyle? get bodyLarge => _textTheme.bodyLarge;
  static TextStyle? get bodyMedium => _textTheme.bodyMedium;
  static TextStyle? get bodySmall => _textTheme.bodySmall;
  static TextStyle? get labelLarge => _textTheme.labelLarge;
  static TextStyle? get labelMedium => _textTheme.labelMedium;
  static TextStyle? get labelSmall => _textTheme.labelSmall;
}
