import 'package:flutter/material.dart';
import '../components/borders.dart';
import '../components/colors.dart';
import 'app_theme.dart';

final ThemeData appDarkTheme = ThemeData(
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: const Color(0xFF121212),
  useMaterial3: true,
  brightness: Brightness.dark,

  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: Color(0xFF1E1E1E),
    error: AppColors.error,
  ),

  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColors.primary,
    selectionColor: Color(0x553498DB),
    selectionHandleColor: AppColors.primary,
  ),

  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    border: AppBorders.outline,
    focusedBorder: AppBorders.focused,
    enabledBorder: OutlineInputBorder(
      borderRadius: AppBorders.radius6,
      borderSide: const BorderSide(color: Color(0xFF555555)),
    ),
    errorBorder: AppBorders.error,
    focusedErrorBorder: AppBorders.error,
    labelStyle: const TextStyle(color: Color(0xFFAAAAAA)),
    hintStyle: const TextStyle(color: Color(0xFF777777)),
    filled: true,
    fillColor: const Color(0xFF1E1E1E),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      textStyle: AppTheme.button,
      shape: AppTheme.buttonShape,
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
  ),

  textTheme: TextTheme(
    titleLarge: AppTheme.heading.copyWith(color: AppColors.white),
    titleMedium: AppTheme.subHeading.copyWith(color: AppColors.white),
    bodyMedium: AppTheme.body.copyWith(color: AppColors.white),
    bodySmall: AppTheme.caption.copyWith(color: const Color(0xFFAAAAAA)),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121212),
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.white),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.white,
    ),
    centerTitle: true,
  ),

  dividerColor: const Color(0xFF333333),
  cardColor: const Color(0xFF1E1E1E),
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xFF1E1E1E),
  ),
);
