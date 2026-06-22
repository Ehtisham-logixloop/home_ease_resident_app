import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/res/components/colors.dart';
import '../../../core/res/components/custom_button.dart';
import '../../../core/res/components/custom_text_field.dart';
import '../../../core/res/components/section_label.dart';
import '../../../core/res/components/strings.dart';
import '../../../core/res/widgets/image_picker_buttons.dart';
import '../../../core/res/widgets/image_preview.dart';
import '../../../core/res/widgets/location_picker_field.dart';
import '../../../core/utils/ui_helper.dart';
import '../../../view_model/create_request_view_model.dart';

import 'date_picker_field.dart';
import 'time_picker_field.dart';
import 'success_dialogue.dart';
class CreateRequestScreen extends StatelessWidget {
  const CreateRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateRequestViewModel(),
      child: const CreateRequestScreenBody(),
    );
  }
}

class CreateRequestScreenBody extends StatelessWidget {
  const CreateRequestScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CreateRequestViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            title: const Text('Create Request'),
            backgroundColor: AppColors.white,
            centerTitle: true,
            leading: const BackButton(),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: vm.categoryController,
                  label: AppStrings.categoryLabel,
                  hint: 'Carpenter',
                ),
                CustomTextField(
                  controller: vm.subCategoryController,
                  label: AppStrings.subCategoryLabel,
                  hint: 'Furniture',
                ),
                CustomTextField(
                  controller: vm.descriptionController,
                  label: AppStrings.problemDescriptionLabel,
                  hint: AppStrings.problemHint,
                  maxLines: 3,
                ),
                const SectionLabel(label: AppStrings.uploadPictureLabel),
                const ImagePreview(),
                const ImagePickerButtons(),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: vm.amountController,
                  label: AppStrings.addAmountLabel,
                  hint: AppStrings.amountHint,
                  keyboardType: TextInputType.number,
                ),
                const DatePickerField(),
                const TimePickerField(),
                const LocationPickerField(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: CustomButton(
                    key: UniqueKey(),
                    text: AppStrings.requestNow,
                    onPressed: () async {
                      final errorMessage = await vm.submitRequest();

                      if (errorMessage == null) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const SuccessDialog(
                            title: AppStrings.successTitle,
                            message: AppStrings.successMessage,
                          ),
                        );
                      } else {
                        UIHelper.showFlushbarError(context, errorMessage); // or use showSnackBar / showToast
                      }
                    },

                    backgroundColor: AppColors.primary,
                    textColor: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (vm.isLoading)
          Center(
              child: const CircularProgressIndicator(
                color: AppColors.primary, // loader color
              ),
            ),
      ],
    );
  }
}

