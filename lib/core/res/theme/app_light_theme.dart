import 'package:flutter/material.dart';
import '../components/borders.dart';
import '../components/colors.dart';
import 'app_theme.dart';

final ThemeData appLightTheme = ThemeData(
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.white,
  useMaterial3: true,

  // Cursor, selection color
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColors.primary,
    selectionColor: Color(0x553498DB),
    selectionHandleColor: AppColors.primary,
  ),

  // Input Fields
  inputDecorationTheme: const InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    border: AppBorders.outline,
    focusedBorder: AppBorders.focused,
    enabledBorder: AppBorders.outline,
    errorBorder: AppBorders.error,
    focusedErrorBorder: AppBorders.error,
    labelStyle: TextStyle(color: AppColors.grey),
  ),

  // Elevated Button Style
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      textStyle: AppTheme.button,
      shape: AppTheme.buttonShape,
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
  ),

  // Text styles
  textTheme: const TextTheme(
    titleLarge: AppTheme.heading,
    titleMedium: AppTheme.subHeading,
    bodyMedium: AppTheme.body,
    bodySmall: AppTheme.caption,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.black),
    titleTextStyle: AppTheme.heading,
    centerTitle: true,
  ),
);

