import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_model/create_request_view_model.dart';
import '../components/borders.dart';
import '../components/colors.dart';
import '../components/strings.dart';

class ImagePickerButtons extends StatelessWidget {
  const ImagePickerButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<CreateRequestViewModel>();

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 54,
            child: OutlinedButton.icon(
              onPressed: vm.pickCameraImage,
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text(AppStrings.c),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.black,
                side: const BorderSide(color: AppColors.grey),
                shape: RoundedRectangleBorder(borderRadius: AppBorders.radius4),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 54,
            child: OutlinedButton.icon(
              onPressed: vm.pickGalleryImage,
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text(AppStrings.g),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.black,
                side: const BorderSide(color: AppColors.grey),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

