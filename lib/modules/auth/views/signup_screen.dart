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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: authController.signupFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Create an account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
                      color: Colors.blue),
                ),
                CustomTextField(
                  label: "Email",
                  hint: "Enter email",
                  controller: authController.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: FormValidator.validEmail,
                  prefixIcon: const Icon(Icons.email_outlined,
                      color: Colors.blue),
                ),
                CustomTextField(
                  label: "Phone number",
                  hint: "Enter number",
                  controller: authController.phoneController,
                  keyboardType: TextInputType.phone,
                  validator: FormValidator.validPhone,
                  prefixIcon: const Icon(Icons.phone_outlined,
                      color: Colors.blue),
                ),
                CustomTextField(
                  label: "Password",
                  hint: "Enter password",
                  controller: authController.passwordController,
                  obscureText: _obscurePassword,
                  validator: FormValidator.validPassword,
                  prefixIcon:
                  const Icon(Icons.lock_outline, color: Colors.blue),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
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
                  const Icon(Icons.lock_outline, color: Colors.blue),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
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
                const Center(child: Text("or continue with")),
                const SizedBox(height: 26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton("assets/icons/google.png"),
                    const SizedBox(width: 50),
                    _socialButton("assets/icons/facebook.png"),
                    const SizedBox(width: 50),
                    _socialButton("assets/icons/apple.png"),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
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

  Widget _socialButton(String icon) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(icon, height: 24),
      ),
    );
  }
}
