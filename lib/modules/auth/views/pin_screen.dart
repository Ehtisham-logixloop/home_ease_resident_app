import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/res/components/custom_button.dart';
import '../../../view_model/auth_view_model.dart';

import 'forgot_screen.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authVM, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Form(
                key: authVM.otpFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 28),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgetScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Enter your 4 digits code",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Please check your email or phone number and enter your 4 digits code",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // OTP Input
                    PinCodeTextField(
                      appContext: context,
                      controller: _pinController,
                      length: 4,
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.fade,
                      validator: (val) {
                        if (val == null || val.length < 4) {
                          return "Enter valid 4 digit code";
                        }
                        return null;
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.circle,
                        borderRadius: BorderRadius.circular(10),
                        fieldHeight: 40,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        activeColor: Colors.grey,
                        inactiveColor: Colors.grey,
                        selectedColor: Colors.blue,
                      ),
                      enableActiveFill: false,
                      onChanged: (value) {},
                      onCompleted: (value) {
                        authVM.otpController.text = value;
                      },
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Didn’t get the code? ",
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {
                          },
                          child: const Text(
                            "Resend",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                    CustomButton(
                      text: authVM.loading ? "Please wait..." : "Continue",
                      loading: authVM.loading,
                      onPressed: authVM.loading
                          ? null
                          : () => authVM.verifyOtp(context),
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

