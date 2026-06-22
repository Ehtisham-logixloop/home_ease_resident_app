import 'package:flutter/material.dart';

import '../../../core/res/components/custom_button.dart';
import '../../../core/res/components/dimensions.dart';


class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white.withOpacity(0.95),
      insetPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.dialogPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.dialogBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.dialogPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/done.png', // can move to constants if needed
              width: AppDimensions.iconSize,
              height: AppDimensions.iconSize,
            ),
            SizedBox(height: AppDimensions.spacingMedium),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.spacingSmall),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.spacingLarge),
            CustomButton(
              text: "Done",
              width: 100,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

