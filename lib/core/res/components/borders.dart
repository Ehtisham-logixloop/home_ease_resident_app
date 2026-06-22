import 'package:flutter/material.dart';

import 'colors.dart';


class AppBorders {
  static const BorderRadius radius4 = BorderRadius.all(Radius.circular(4));
  static const BorderRadius radius6 = BorderRadius.all(Radius.circular(6));
  static const BorderRadius radius8 = BorderRadius.all(Radius.circular(8));

  static const OutlineInputBorder outline = OutlineInputBorder(
    borderRadius: radius6,
    borderSide: BorderSide(color: AppColors.grey, width: 1),
  );

  static const OutlineInputBorder error = OutlineInputBorder(
    borderRadius: radius6,
    borderSide: BorderSide(color: AppColors.error, width: 1),
  );

  static const OutlineInputBorder focused = OutlineInputBorder(
    borderRadius: radius6,
    borderSide: BorderSide(color: AppColors.primary, width: 1),
  );

  static final BorderSide button = BorderSide(color: Colors.grey.shade400, width: 1);

  static const BoxDecoration switchTile = BoxDecoration(
    border: Border.fromBorderSide(BorderSide(color: AppColors.grey, width: 1)),
    borderRadius: radius6,
  );
}


