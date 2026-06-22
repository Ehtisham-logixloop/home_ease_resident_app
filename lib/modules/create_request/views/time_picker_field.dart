import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/res/components/colors.dart';
import '../../../core/res/components/custom_text_field.dart';
import '../../../core/res/components/strings.dart';
import '../../../view_model/create_request_view_model.dart';
// ✅ Import your custom field

class TimePickerField extends StatelessWidget {
  const TimePickerField({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateRequestViewModel>();

    return CustomTextField(
      label: AppStrings.selectTime,
      hint: vm.selectedTime?.format(context) ?? AppStrings.timeHint,
      readOnly: true,
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: vm.selectedTime ?? TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                ),
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
        if (picked != null) vm.setSelectedTime(picked);
      },
    );
  }
}

