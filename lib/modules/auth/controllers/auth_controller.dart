import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/routes/routes_name.dart';
import '../../../core/utils/ui_helper.dart';

class AuthController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();
  final forgotFormKey = GlobalKey<FormState>();
  final setFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();

  var loading = false.obs;

  void setLoading(bool value) {
    loading.value = value;
  }

  void clearControllers() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phoneController.clear();
    otpController.clear();
  }

  bool _validateForm(GlobalKey<FormState> formKey, String errorMsg) {
    if (!(formKey.currentState?.validate() ?? false)) {
      UIHelper.showFlushbarError(Get.context!, errorMsg);
      return false;
    }
    return true;
  }

  bool _passwordsMatch() {
    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      UIHelper.showFlushbarError(Get.context!, "Passwords do not match");
      return false;
    }
    return true;
  }

  Future<void> login() async {
    if (!_validateForm(loginFormKey, "Please fill in all fields correctly")) return;
    try {
      setLoading(true);
      UIHelper.showFlushbarSuccess(Get.context!, "Login successful ");
      clearControllers();
      Get.offAllNamed(RoutesName.home);
    } catch (e) {
      UIHelper.showFlushbarError(Get.context!, "Login failed: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> signup() async {
    if (!_validateForm(signupFormKey, "Please fill all fields correctly")) return;
    if (!_passwordsMatch()) return;
    try {
      setLoading(true);
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        UIHelper.showFlushbarSuccess(Get.context!, "Signup successful");
        clearControllers();
        Get.offAllNamed(RoutesName.login);
      } else {
        UIHelper.showFlushbarError(Get.context!, "Signup failed. Try again.");
      }
    } catch (e) {
      UIHelper.showFlushbarError(Get.context!, "Signup failed: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<bool> sendOtp() async {
    if (!_validateForm(forgotFormKey, "Enter your email or phone")) return false;
    try {
      setLoading(true);
      UIHelper.showFlushbarSuccess(Get.context!, "OTP sent successfully");
      Get.toNamed(RoutesName.pin);
      return true;
    } catch (e) {
      UIHelper.showFlushbarError(Get.context!, "Failed to send OTP: $e");
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> verifyOtp() async {
    if (!_validateForm(otpFormKey, "Enter the 4-digit code")) return;
    try {
      setLoading(true);
      UIHelper.showFlushbarSuccess(Get.context!, "OTP verified successfully");
      Get.toNamed(RoutesName.setPassword);
    } catch (e) {
      UIHelper.showFlushbarError(Get.context!, "Verification failed: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> setPassword() async {
    if (!_validateForm(setFormKey, "Please fill in all fields correctly")) return;
    if (!_passwordsMatch()) return;
    try {
      setLoading(true);
      UIHelper.showFlushbarSuccess(Get.context!, "Password reset successfully");
      clearControllers();
      Get.offAllNamed(RoutesName.login);
    } catch (e) {
      UIHelper.showFlushbarError(Get.context!, "Failed to set password: $e");
    } finally {
      setLoading(false);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
