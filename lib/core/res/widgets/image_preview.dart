import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../../view_model/create_request_view_model.dart';
import '../components/borders.dart';
import '../components/colors.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateRequestViewModel>();

    if (vm.selectedImage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: AppBorders.radius6,
            child: Image.file(
              vm.selectedImage!,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: InkWell(
              onTap: vm.clearImage,
              child: const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.black54,
                child: Icon(Icons.close, size: 16, color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

