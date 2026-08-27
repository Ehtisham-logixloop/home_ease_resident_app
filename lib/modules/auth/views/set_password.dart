import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/res/components/custom_button.dart';
import '../../../core/res/components/custom_text_field.dart';
import '../../../core/utils/routes/routes_name.dart';
import '../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({super.key});

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white70 : Colors.grey;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: authController.setFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, size: 28, color: titleColor),
                  onPressed: () => Get.offNamed(RoutesName.pin),
                ),
                const SizedBox(height: 30),
                Text(
                  "New password",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  label: " New Password",
                  hint: "Enter password",
                  controller: authController.passwordController,
                  obscureText: _obscurePassword,
                  validator: FormValidator.validPassword,
                  prefixIcon:
                  const Icon(Icons.lock_outline, color: Color(0xFF3B82F6)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: subColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                CustomTextField(
                  label: "Confirm password",
                  hint: "Re-enter password",
                  controller: authController.confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  validator: FormValidator.validPassword,
                  prefixIcon:
                  const Icon(Icons.lock_outline, color: Color(0xFF3B82F6)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: subColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 40),
                Obx(
                  () => CustomButton(
                    text: authController.loading.value ? "Please wait..." : 'Save',
                    loading: authController.loading.value,
                    onPressed: authController.loading.value
                        ? null
                        : () => authController.setPassword(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
