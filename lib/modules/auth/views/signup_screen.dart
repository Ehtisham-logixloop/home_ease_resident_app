import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/res/components/custom_button.dart';
import '../../../core/res/components/custom_text_field.dart';
import '../../../core/utils/routes/routes_name.dart';
import '../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscurePassword = true;
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : Colors.black;
    final bodyColor = isDark ? Colors.white70 : Colors.grey;
    final socialBorder = isDark ? Colors.grey.shade700 : Colors.grey.shade200;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: authController.signupFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Text(
                  "Create an account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  label: "User name",
                  hint: "Enter name",
                  controller: authController.nameController,
                  validator: (val) =>
                      FormValidator.notEmpty(val, fieldName: "Name"),
                  prefixIcon: const Icon(Icons.person_outline,
                      color: Color(0xFF3B82F6)),
                ),
                CustomTextField(
                  label: "Email",
                  hint: "Enter email",
                  controller: authController.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: FormValidator.validEmail,
                  prefixIcon: const Icon(Icons.email_outlined,
                      color: Color(0xFF3B82F6)),
                ),
                CustomTextField(
                  label: "Phone number",
                  hint: "Enter number",
                  controller: authController.phoneController,
                  keyboardType: TextInputType.phone,
                  validator: FormValidator.validPhone,
                  prefixIcon: const Icon(Icons.phone_outlined,
                      color: Color(0xFF3B82F6)),
                ),
                CustomTextField(
                  label: "Password",
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
                      color: bodyColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                CustomTextField(
                  label: "Confirm Password",
                  hint: "Re-enter password",
                  controller: authController.confirmPasswordController,
                  obscureText: _obscurePassword,
                  validator: FormValidator.validPassword,
                  prefixIcon:
                  const Icon(Icons.lock_outline, color: Color(0xFF3B82F6)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: bodyColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 40),
                Obx(() => CustomButton(
                  text: "Sign Up",
                  loading: authController.loading.value,
                  onPressed: () => authController.signup(),
                )),
                const SizedBox(height: 30),
                Center(child: Text("or continue with", style: TextStyle(color: bodyColor))),
                const SizedBox(height: 26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton("assets/icons/google.png", socialBorder),
                    const SizedBox(width: 50),
                    _socialButton("assets/icons/facebook.png", socialBorder),
                    const SizedBox(width: 50),
                    _socialButton("assets/icons/apple.png", socialBorder),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?", style: TextStyle(color: bodyColor)),
                    InkWell(
                      onTap: () => Get.offAllNamed(RoutesName.login),
                      child: const Text(
                        " Log In",
                        style: TextStyle(
                          color: Color(0xFF3B82F6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton(String icon, Color borderColor) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(icon, height: 24),
      ),
    );
  }
}
