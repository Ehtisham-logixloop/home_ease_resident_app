import 'package:flutter/material.dart';
import '../components/colors.dart';
import '../components/borders.dart';

class AppTheme {
  // Text styles
  static const TextStyle heading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const TextStyle subHeading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.grey,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  // Spacing
  static const EdgeInsets screenPadding = EdgeInsets.all(16);
  static const EdgeInsets fieldPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const SizedBox verticalSpaceSmall = SizedBox(height: 8);
  static const SizedBox verticalSpaceMedium = SizedBox(height: 16);
  static const SizedBox verticalSpaceLarge = SizedBox(height: 24);

  // Button shape
  static final RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
    borderRadius: AppBorders.radius6,
  );
}

