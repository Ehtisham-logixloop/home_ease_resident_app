import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_ease_resident_app/modules/auth/bindings/auth_binding.dart';
import 'package:home_ease_resident_app/providers/providers.dart';

import 'package:provider/provider.dart';

import 'core/res/components/strings.dart';
import 'core/res/theme/app_light_theme.dart';
import 'core/utils/routes/routes.dart';
import 'core/utils/routes/routes_name.dart';

void main() {
  runApp(
    MultiProvider(
      providers: appProviders,
        child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.title,
      debugShowCheckedModeBanner: false,
      theme: appLightTheme,
     initialRoute: RoutesName.splash,
      onGenerateRoute: Routes.generateRoute,
      initialBinding: AuthBinding(),
    );
  }
}



