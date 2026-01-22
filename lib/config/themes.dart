import 'package:flutter/material.dart';

var lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  colorScheme: ColorScheme(
  brightness: Brightness.light,

  // Primary
  primary: Color(0xFF2563EB), // Blue 600
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFDBEAFE),
  onPrimaryContainer: Color(0xFF0F172A),

  // Secondary
  secondary: Color(0xFF007E6E), // Teal 500
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFCCFBF1),
  onSecondaryContainer: Color(0xFF042F2E),

  // Tertiary (Accent / highlight)
  tertiary: Color(0xFF6366F1), // Indigo
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFE0E7FF),
  onTertiaryContainer: Color(0xFF1E1B4B),

  // Error
  error: Color(0xFFDC2626),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFEE2E2),
  onErrorContainer: Color(0xFF450A0A),

  // Surface & Background
  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF0F172A),
  surfaceContainerHighest: Color(0xFFF1F5F9),
  onSurfaceVariant: Color(0xFF475569),

  // Outline & Others
  outline: Color(0xFFCBD5E1),
  outlineVariant: Color(0xFFE2E8F0),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF0F172A),
  onInverseSurface: Color(0xFFF8FAFC),
  inversePrimary: Color(0xFF93C5FD),
  surfaceTint: Color(0xFF2563EB),
),

  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 40,
      fontWeight: FontWeight.w600, // Outfit-Bold (600)
      height: 1.15,
    ),

    headlineMedium: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.2,
    ),

    headlineSmall: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.25,
    ),

    titleLarge: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.25,
    ),

    titleMedium: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.25,
    ),

    titleSmall: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.2,
    ),

    bodyLarge: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 18,
      fontWeight: FontWeight.w400, // Outfit-Regular
      height: 1.4,
    ),

    bodyMedium: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),

    bodySmall: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 14,
      fontWeight: FontWeight.w300, // Outfit-ExtraLight
      height: 1.3,
    ),

    labelLarge: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      height: 1.2,
    ),

    labelMedium: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.2,
    ),

    labelSmall: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.1,
    ),
  ),
);

var darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  colorScheme: ColorScheme(
  brightness: Brightness.dark,

  // Primary
  primary: Color(0xFF93C5FD), // Light Blue
  onPrimary: Color(0xFF0F172A),
  primaryContainer: Color(0xFF1E40AF),
  onPrimaryContainer: Color(0xFFDBEAFE),

  // Secondary
  secondary: Color(0xFF16C47F),
  onSecondary: Color(0xFF042F2E),
  secondaryContainer: Color(0xFF134E4A),
  onSecondaryContainer: Color(0xFFCCFBF1),

  // Tertiary
  tertiary: Color(0xFFA5B4FC),
  onTertiary: Color(0xFF1E1B4B),
  tertiaryContainer: Color(0xFF312E81),
  onTertiaryContainer: Color(0xFFE0E7FF),

  // Error
  error: Color(0xFFF63049),
  onError: Color(0xFF450A0A),
  errorContainer: Color(0xFF7F1D1D),
  onErrorContainer: Color(0xFFFEE2E2),

  // Surface & Background
  surface: Color(0xFF020617),
  onSurface: Color(0xFFE5E7EB),
  surfaceContainerHighest: Color(0xFF1E293B),
  onSurfaceVariant: Color(0xFFCBD5E1),

  // Outline & Others
  outline: Color(0xFF475569),
  outlineVariant: Color(0xFF334155),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFE5E7EB),
  onInverseSurface: Color(0xFF020617),
  inversePrimary: Color(0xFF2563EB),
  surfaceTint: Color(0xFF93C5FD),
),

  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 40,
      fontWeight: FontWeight.w600, // Outfit-Bold (600)
      height: 1.15,
    ),

    headlineMedium: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.2,
    ),

    headlineSmall: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.25,
    ),

    titleLarge: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.25,
    ),

    titleMedium: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.25,
    ),

    titleSmall: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.2,
    ),

    bodyLarge: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 18,
      fontWeight: FontWeight.w400, // Outfit-Regular
      height: 1.4,
    ),

    bodyMedium: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),

    bodySmall: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 14,
      fontWeight: FontWeight.w300, // Outfit-ExtraLight
      height: 1.3,
    ),

    labelLarge: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      height: 1.2,
    ),

    labelMedium: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.2,
    ),

    labelSmall: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.1,
    ),
  ),
);
