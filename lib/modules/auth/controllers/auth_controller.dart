import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/routes/routes_name.dart';
import '../../../core/utils/ui_helper.dart';
import '../../../core/res/app_url.dart';
import '../../../data/services/api_service.dart';
import '../../../core/services/local_storage_service.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  
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

  String? _resetEmail;
  String? _resetPin;

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
      
      final response = await _apiService.postRequest(
        AppUrl.login,
        {
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );

      if (response['success']) {
        final data = response['data'];
        await LocalStorageService.saveAuthData(
          token: data['token'],
          userId: data['user']['id'],
          userName: data['user']['name'],
          userEmail: data['user']['email'],
          userRole: data['user']['role'],
          approvalStatus: data['user']['approval_status'],
        );
        UIHelper.showFlushbarSuccess(Get.context!, "Login successful");
        clearControllers();
        Get.offAllNamed(RoutesName.home);
      } else {
        UIHelper.showFlushbarError(Get.context!, response['message']);
      }
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
      
      final response = await _apiService.postRequest(
        AppUrl.register,
        {
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'phone': phoneController.text.trim(),
          'role': 'resident',
        },
      );

      if (response['success']) {
        UIHelper.showFlushbarSuccess(Get.context!, "Signup successful");
        clearControllers();
        Get.offAllNamed(RoutesName.login);
      } else {
        UIHelper.showFlushbarError(Get.context!, response['message']);
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

      final email = emailController.text.trim();
      final response = await _apiService.postRequest(
        AppUrl.forgotPassword,
        {
          'email': email,
        },
      );

      if (response['success']) {
        _resetEmail = email;
        otpController.clear();
        UIHelper.showFlushbarSuccess(Get.context!, response['message'] ?? "OTP sent successfully");
        Get.offNamed(RoutesName.pin);
        return true;
      } else {
        UIHelper.showFlushbarError(Get.context!, response['message']);
        return false;
      }
    } catch (e) {
      UIHelper.showFlushbarError(Get.context!, "Failed to send OTP: $e");
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> verifyOtp() async {
    if (!_validateForm(otpFormKey, "Enter the 4-digit code")) return;
    if (otpController.text.trim().length != 4) {
      UIHelper.showFlushbarError(Get.context!, "Enter a valid 4-digit code");
      return;
    }
    if (_resetEmail == null) {
      UIHelper.showFlushbarError(Get.context!, "Please request a new PIN first");
      return;
    }
    try {
      setLoading(true);

      final pin = otpController.text.trim();
      final response = await _apiService.postRequest(
        AppUrl.verifyPin,
        {
          'email': _resetEmail!,
          'pin': pin,
        },
      );

      if (response['success']) {
        _resetPin = pin;
        UIHelper.showFlushbarSuccess(Get.context!, "OTP verified successfully");
        Get.offNamed(RoutesName.setPassword);
      } else {
        UIHelper.showFlushbarError(Get.context!, response['message']);
      }
    } catch (e) {
      UIHelper.showFlushbarError(Get.context!, "Verification failed: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> setPassword() async {
    if (!_validateForm(setFormKey, "Please fill in all fields correctly")) return;
    if (!_passwordsMatch()) return;
    if (_resetEmail == null || _resetPin == null) {
      UIHelper.showFlushbarError(Get.context!, "Please complete verification first");
      return;
    }
    try {
      setLoading(true);

      final response = await _apiService.postRequest(
        AppUrl.resetPassword,
        {
          'email': _resetEmail!,
          'pin': _resetPin!,
          'newPassword': passwordController.text.trim(),
          'confirmPassword': confirmPasswordController.text.trim(),
        },
      );

      if (response['success']) {
        UIHelper.showFlushbarSuccess(Get.context!, response['message'] ?? "Password reset successfully");
        clearControllers();
        _resetEmail = null;
        _resetPin = null;
        if (await LocalStorageService.isLoggedIn()) {
          Get.offAllNamed(RoutesName.home);
        } else {
          Get.offAllNamed(RoutesName.login);
        }
      } else {
        UIHelper.showFlushbarError(Get.context!, response['message']);
      }
    } catch (e) {
      UIHelper.showFlushbarError(Get.context!, "Failed to set password: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      setLoading(true);
      await LocalStorageService.clearAuthData();
      clearControllers();
      _resetEmail = null;
      _resetPin = null;
      Get.offAllNamed(RoutesName.login);
    } catch (e) {
      UIHelper.showFlushbarError(Get.context!, "Logout failed: $e");
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
