import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/res/components/custom_button.dart';
import '../../../view_model/auth_view_model.dart';


class ForgetScreen extends StatelessWidget {
  const ForgetScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Form(
            key: authVM.forgotFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Forget password",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Please enter your email or phone number. We will send a code to your mail or number to reset your password",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 60),
                const Text(
                  "Email or Phone number",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: authVM.emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter email or phone number";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Enter email or number...",
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                CustomButton(
                  text: authVM.loading ? "Please wait..." : "Continue",
                  loading: authVM.loading,
                  onPressed: authVM.loading
                      ? null
                      : () => authVM.sendOtp(context),
                  //Navigator.pushReplacementNamed(context, RoutesName.login);
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

