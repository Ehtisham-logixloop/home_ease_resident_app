import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/res/components/custom_button.dart';
import '../../../core/res/components/custom_text_field.dart';
import '../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';


class ForgetScreen extends StatelessWidget {
  const ForgetScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white70 : Colors.grey;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Form(
            key: authController.forgotFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, size: 28,
                      color: titleColor),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 30),
                Text(
                  "Forget password",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Please enter your email or phone number. We will send a code to your mail or number to reset your password",
                  style: TextStyle(
                    fontSize: 15,
                    color: subColor,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  label: "Email or Phone number",
                  hint: "Enter email or number...",
                  controller: authController.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      FormValidator.notEmpty(value, fieldName: "Email or phone number"),
                  prefixIcon: const Icon(
                    Icons.alternate_email,
                    color: Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(height: 50),
                Obx(
                  () => CustomButton(
                    text: authController.loading.value ? "Please wait..." : "Continue",
                    loading: authController.loading.value,
                    onPressed: authController.loading.value
                        ? null
                        : () => authController.sendOtp(),
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
