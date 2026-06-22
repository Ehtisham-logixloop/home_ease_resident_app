import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';
import '../../../core/res/components/borders.dart';
import '../../../core/res/components/colors.dart';
import '../../../core/res/components/custom_button.dart';
import '../../../core/res/components/custom_switch_tile.dart';
import '../../../core/res/components/strings.dart';
import '../../../view_model/map_field_view_model.dart';


class MapFieldScreen extends StatelessWidget {
  const MapFieldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapFieldViewModel(),
      child: const _MapFieldBody(),
    );
  }
}

class _MapFieldBody extends StatelessWidget {
  const _MapFieldBody({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MapFieldViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Map',
          style: TextStyle(color: AppColors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 22),
            // Google Map / Placeholder
            Container(
              height: 350,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.grey1,
                borderRadius: AppBorders.radius6,
                border: Border.all(color: AppColors.grey),
              ),
              child: vm.selectedLocation == null
                  ? const Center(
                child: Text(
                  'Map will appear here',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
                  : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: vm.selectedLocation!,
                  zoom: 14,
                ),
                onTap: vm.selectLocation,
                markers: {
                  Marker(
                    markerId: const MarkerId('selected'),
                    position: vm.selectedLocation!,
                  )
                },
              ),
            ),
            const SizedBox(height: 16),

            // Switch Tiles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  CustomSwitchTile(
                    icon: Icons.location_on_outlined,
                    title: AppStrings.t,
                    value: vm.useLocationToggle,
                    onChanged: vm.toggleUseLocation,
                  ),
                  const SizedBox(height: 12),
                  CustomSwitchTile(
                    icon: Icons.location_on_outlined,
                    title: AppStrings.C,
                    value: vm.currentLocationToggle,
                    onChanged: vm.toggleCurrentLocation,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomButton(
                text: AppStrings.conf,
                onPressed: () {
                  if (vm.selectedLocation != null) {
                    Navigator.pop(context, vm.selectedLocation);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(AppStrings.pl)),
                    );
                  }
                },
                backgroundColor: AppColors.primary,
                textColor: AppColors.white,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

