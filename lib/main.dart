import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_ease_resident_app/modules/auth/bindings/auth_binding.dart';
import 'package:home_ease_resident_app/providers/providers.dart';
import 'package:home_ease_resident_app/view_model/theme_view_model.dart';

import 'package:provider/provider.dart';

import 'core/res/components/strings.dart';
import 'core/res/theme/app_dark_theme.dart';
import 'core/res/theme/app_light_theme.dart';
import 'core/utils/routes/routes.dart';
import 'core/utils/routes/routes_name.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: appProviders,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ThemeProvider>(context, listen: false).loadThemeMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return GetMaterialApp(
          title: AppStrings.title,
          debugShowCheckedModeBanner: false,
          theme: appLightTheme,
          darkTheme: appDarkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: RoutesName.splash,
          onGenerateRoute: Routes.generateRoute,
          initialBinding: AuthBinding(),
        );
      },
    );
  }
}


