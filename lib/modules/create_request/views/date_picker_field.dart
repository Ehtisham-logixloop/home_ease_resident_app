import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/res/components/colors.dart';
import '../../../core/res/components/custom_text_field.dart';
import '../../../core/res/components/strings.dart';
import '../../../view_model/create_request_view_model.dart';


class DatePickerField extends StatelessWidget {
  const DatePickerField({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateRequestViewModel>();

    return CustomTextField(
      label: AppStrings.selectDate,
      hint: vm.selectedDate != null
          ? "${vm.selectedDate!.day}/${vm.selectedDate!.month}/${vm.selectedDate!.year}"
          : AppStrings.dateHint,
      readOnly: true,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: vm.selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
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

        if (picked != null) {
          vm.setSelectedDate(picked);
          FocusScope.of(context).unfocus();
        }
      },
    );
  }
}

