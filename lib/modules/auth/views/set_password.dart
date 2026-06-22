import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/res/components/custom_button.dart';
import '../../../core/res/components/custom_text_field.dart';
import '../../../core/utils/routes/routes_name.dart';
import '../../../core/utils/validators.dart';
import '../../../view_model/auth_view_model.dart';

import 'pin_screen.dart';

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
    return Consumer<AuthViewModel>(
      builder: (context, authVM, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: authVM.setFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 28),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PinScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "New password",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      label: " New Password",
                      hint: "Enter password",
                      controller: authVM.passwordController,
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
                      label: "Confirm password",
                      hint: "Re-enter password",
                      controller: authVM.confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      prefixIcon:
                      const Icon(Icons.lock_outline, color: Colors.blue),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword =
                            !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomButton(
                      text: 'Save',
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          RoutesName.login,
                        );
                      },
                    ),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

