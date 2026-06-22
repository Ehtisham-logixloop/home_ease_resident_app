import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../view_model/create_request_view_model.dart';
import '../../utils/routes/routes_name.dart';
import '../components/custom_text_field.dart';
import '../components/strings.dart';

class LocationPickerField extends StatelessWidget {
  const LocationPickerField({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateRequestViewModel>();

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.pushNamed(context, RoutesName.map);
        if (result != null && result is LatLng) {
          vm.setSelectedLocation(result);
        }
      },
      child: AbsorbPointer(
        child: CustomTextField(
          label: AppStrings.locationLabel,
          hint: vm.selectedLocation != null
              ? '${vm.selectedLocation!.latitude}, ${vm.selectedLocation!.longitude}'
              : AppStrings.locationHint,
          prefixIcon: const Icon(Icons.location_on_outlined),
        ),
      ),
    );
  }
}

