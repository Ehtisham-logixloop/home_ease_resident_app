
import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/res/components/strings.dart';
import '../../../core/utils/routes/routes_name.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _navigationTimer = Timer(const Duration(seconds: 2), () async {
      final isLoggedIn = await LocalStorageService.isLoggedIn();
      final initialRoute = isLoggedIn
          ? RoutesName.home
          : RoutesName.login;

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        initialRoute,
        (route) => false,
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 60,
              width: 60,
            ),
            const SizedBox(width: 12),
            Text(AppStrings.fix,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
