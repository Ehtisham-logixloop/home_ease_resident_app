import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../core/res/components/colors.dart';
import '../../../core/utils/routes/routes_name.dart';
import '../../../view_model/theme_view_model.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../Bottom_navigation/views/bottom_navigation.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          "My Profile",
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/images/profile_image.png"),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt,
                        size: 18, color: Colors.white),
                  )
                ],
              ),
              const SizedBox(height: 40),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.editProfile);
                },
                leading: Icon(Icons.perm_identity_outlined,
                    color: isDark ? Colors.white70 : Colors.black87),
                title: Text("Edit Profile",
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white : Colors.black87)),
                trailing: Icon(Icons.arrow_forward_ios,
                    size: 14, color: isDark ? Colors.white54 : Colors.black54),
              ),
              const Divider(),
              ListTile(
                onTap: () {
                  Get.toNamed(RoutesName.forgot);
                },
                leading: Icon(Icons.local_mall_outlined,
                    color: isDark ? Colors.white70 : Colors.black87),
                title: Text("Change Password",
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white : Colors.black87)),
                trailing: Icon(Icons.arrow_forward_ios,
                    size: 14, color: isDark ? Colors.white54 : Colors.black54),
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.calendar_month,
                    color: isDark ? Colors.white70 : Colors.black87),
                title: Text("My Bookings",
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white : Colors.black87)),
                trailing: Icon(Icons.arrow_forward_ios,
                    size: 14, color: isDark ? Colors.white54 : Colors.black54),
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.location_on_outlined,
                    color: isDark ? Colors.white70 : Colors.black87),
                title: Text("My Address",
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white : Colors.black87)),
                trailing: Icon(Icons.arrow_forward_ios,
                    size: 14, color: isDark ? Colors.white54 : Colors.black54),
              ),
              const Divider(),
              Consumer<ThemeProvider>(
                builder: (context, provider, child) {
                  final darkEnabled = provider.isDarkMode ||
                      (provider.isSystemMode && isDark);
                  return ListTile(
                    leading: Icon(
                      darkEnabled
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                      color: AppColors.primary,
                    ),
                    title: Text("Dark Mode",
                        style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white : Colors.black87)),
                    trailing: Transform.scale(
                      scale: 0.6,
                      child: Switch(
                        value: darkEnabled,
                        activeThumbColor: AppColors.primary,
                        onChanged: (val) {
                          provider.toggleDarkMode(val);
                        },
                      ),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.shield_outlined,
                    color: isDark ? Colors.white70 : Colors.black87),
                title: Text("My Privacy",
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white : Colors.black87)),
                trailing: Icon(Icons.arrow_forward_ios,
                    size: 14, color: isDark ? Colors.white54 : Colors.black54),
              ),
              const Divider(),
              ListTile(
                onTap: () => authController.logout(),
                leading: Icon(Icons.logout, color: AppColors.primary),
                title: const Text("Log out",
                    style: TextStyle(color: AppColors.primary, fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 3),
    );
  }
}
