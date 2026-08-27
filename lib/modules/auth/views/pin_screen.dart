import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/res/components/custom_button.dart';
import '../../../core/utils/routes/routes_name.dart';
import '../controllers/auth_controller.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white70 : Colors.grey;
    final fieldFill = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark ? Colors.grey.shade600 : Colors.grey;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: authController.otpFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, size: 28, color: titleColor),
                  onPressed: () => Get.offNamed(RoutesName.forgot),
                ),
                const SizedBox(height: 30),
                Text(
                  "Enter your 4 digits code",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Please check your email or phone number and enter your 4 digits code",
                  style: TextStyle(
                    fontSize: 15,
                    color: subColor,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 40),
                PinCodeTextField(
                  appContext: context,
                  controller: _pinController,
                  length: 4,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  textStyle: TextStyle(color: titleColor),
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
                    activeFillColor: fieldFill,
                    inactiveFillColor: fieldFill,
                    selectedFillColor: fieldFill,
                    activeColor: borderColor,
                    inactiveColor: borderColor,
                    selectedColor: Colors.blue,
                  ),
                  enableActiveFill: true,
                  onChanged: (value) {
                    authController.otpController.text = value;
                  },
                  onCompleted: (value) {
                    authController.otpController.text = value;
                  },
                ),
                const SizedBox(height: 20),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't get the code? ",
                        style: TextStyle(fontSize: 15, color: subColor),
                      ),
                      GestureDetector(
                        onTap: authController.loading.value
                            ? null
                            : () async {
                                final resent = await authController.sendOtp();
                                if (resent) {
                                  _pinController.clear();
                                }
                              },
                        child: Text(
                          "Resend",
                          style: TextStyle(
                            fontSize: 15,
                            color: authController.loading.value ? subColor : Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                Obx(
                  () => CustomButton(
                    text: authController.loading.value ? "Please wait..." : "Continue",
                    loading: authController.loading.value,
                    onPressed: authController.loading.value
                        ? null
                        : () => authController.verifyOtp(),
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
