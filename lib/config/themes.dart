import 'package:expense_tracker/config/colors.dart';
import 'package:flutter/material.dart';

var lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  colorScheme: ColorScheme(
    brightness: Brightness.light, 
    primary: primaryColor, 
    onPrimary: onPrimaryColor, 
    secondary: primaryColor, 
    onSecondary: onPrimaryColor, 
    error: errorColor, 
    onError: onPrimaryColor, 
    surface: onPrimaryColor, 
    onSurface: Colors.black),

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
