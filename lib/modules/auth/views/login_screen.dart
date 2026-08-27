import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/res/components/custom_button.dart';
import '../../../core/res/components/custom_text_field.dart';
import '../../../core/utils/routes/routes_name.dart';
import '../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
            key: authController.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 50),
                CustomTextField(
                  label: "Email",
                  hint: "Enter email",
                  controller: authController.emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF3B82F6)),
                  validator: FormValidator.validEmail,
                ),

                CustomTextField(
                  label: "Password",
                  hint: "Enter password",
                  controller: authController.passwordController,
                  obscureText: _obscurePassword,
                  validator: FormValidator.validPassword,
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF3B82F6)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: bodyColor,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () => Get.toNamed(RoutesName.forgot),
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(color: Color(0xFF3B82F6)),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Obx(() => CustomButton(
                  text: "Login",
                  loading: authController.loading.value,
                  onPressed: () => authController.login(),
                )),
                const SizedBox(height: 40),
                Center(
                  child: Text("-------------------- or continue with --------------------",
                      style: TextStyle(color: bodyColor)),
                ),
                const SizedBox(height: 40),
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
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?", style: TextStyle(color: bodyColor)),
                    InkWell(
                      onTap: () => Get.toNamed(RoutesName.signup),
                      child: const Text(
                        " Sign up",
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
