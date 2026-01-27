import 'package:flutter/material.dart';

/// Theme Helper for caching color scheme to reduce Theme.of() calls
/// This improves performance on low-end devices by avoiding widget tree traversals
class ThemeHelper {
  // Use nullable backing fields so getters can fall back to defaults during tests
  static ColorScheme? _colorScheme;
  static TextTheme? _text_theme;

  /// Initialize theme colors - call this once in your app startup
  static void init(BuildContext context) {
    _colorScheme = Theme.of(context).colorScheme;
    _text_theme = Theme.of(context).textTheme;
  }

  // Internal safe accessors that fall back to a default ThemeData when not initialized
  static ColorScheme get _cs => _colorScheme ?? ThemeData.light().colorScheme;
  static TextTheme get _tt => _text_theme ?? ThemeData.light().textTheme;

  // Color Scheme Accessors (use safe internal getters)
  static Color get primary => _cs.primary;
  static Color get onPrimary => _cs.onPrimary;
  static Color get primaryContainer => _cs.primaryContainer;
  static Color get secondary => _cs.secondary;
  static Color get onSecondary => _cs.onSecondary;
  static Color get secondaryContainer => _cs.secondaryContainer;
  static Color get onSecondaryContainer => _cs.onSecondaryContainer;
  static Color get tertiary => _cs.tertiary;
  static Color get onTertiary => _cs.onTertiary;
  static Color get error => _cs.error;
  static Color get onError => _cs.onError;
  static Color get errorContainer => _cs.errorContainer;
  static Color get onErrorContainer => _cs.onErrorContainer;
  static Color get surface => _cs.surface;
  static Color get onSurface => _cs.onSurface;
  static Color get outline => _cs.outline;
  static Color get outlineVariant => _cs.outlineVariant;
  static Color get inverseSurface => _cs.inverseSurface;
  static Color get surfaceVariant => _cs.surfaceContainerHighest;
  static Color get onSurfaceVariant => _cs.onSurfaceVariant;
  static Color get surfaceContainerHighest => _cs.surfaceContainerHighest;
  static Color get surfaceBright => _cs.surfaceTint; // fallback
  static Color get surfaceDim => _cs.surface; // fallback
  static Color get scrim => _cs.scrim;

  // Text Theme Accessors (safe)
  static TextStyle? get displayLarge => _tt.displayLarge;
  static TextStyle? get displayMedium => _tt.displayMedium;
  static TextStyle? get displaySmall => _tt.displaySmall;
  static TextStyle? get headlineLarge => _tt.headlineLarge;
  static TextStyle? get headlineMedium => _tt.headlineMedium;
  static TextStyle? get headlineSmall => _tt.headlineSmall;
  static TextStyle? get titleLarge => _tt.titleLarge;
  static TextStyle? get titleMedium => _tt.titleMedium;
  static TextStyle? get titleSmall => _tt.titleSmall;
  static TextStyle? get bodyLarge => _tt.bodyLarge;
  static TextStyle? get bodyMedium => _tt.bodyMedium;
  static TextStyle? get bodySmall => _tt.bodySmall;
  static TextStyle? get labelLarge => _tt.labelLarge;
  static TextStyle? get labelMedium => _tt.labelMedium;
  static TextStyle? get labelSmall => _tt.labelSmall;
}

class TH extends ThemeHelper {}
