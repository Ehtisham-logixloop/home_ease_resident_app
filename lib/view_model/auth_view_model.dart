import 'package:flutter/material.dart';
import '../core/utils/routes/routes_name.dart';
import '../core/utils/ui_helper.dart';
import '../core/res/app_url.dart';
import '../data/services/api_service.dart';

class AuthViewModel extends ChangeNotifier {
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

  bool _loading = false;
  bool get loading => _loading;

  String? _resetEmail;
  String? _resetPin;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void clearControllers() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phoneController.clear();
    otpController.clear();
  }

  bool _validateForm(GlobalKey<FormState> formKey, BuildContext context, String errorMsg) {
    if (!(formKey.currentState?.validate() ?? false)) {
      UIHelper.showFlushbarError(context, errorMsg);
      return false;
    }
    return true;
  }

  bool _passwordsMatch(BuildContext context) {
    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      UIHelper.showFlushbarError(context, "Passwords do not match");
      return false;
    }
    return true;
  }

  Future<void> login(BuildContext context) async {
    if (!_validateForm(loginFormKey, context, "Please fill in all fields correctly")) return;
    try {
      setLoading(true);
      UIHelper.showFlushbarSuccess(context, "Login successful ");
      clearControllers();
      Navigator.pushReplacementNamed(context, RoutesName.home);
    } catch (e) {
      UIHelper.showFlushbarError(context, "Login failed: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> signup(BuildContext context) async {
    if (!_validateForm(signupFormKey, context, "Please fill all fields correctly")) return;
    if (!_passwordsMatch(context)) return;
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
        UIHelper.showFlushbarSuccess(context, "Signup successful");
        clearControllers();
        Navigator.pushReplacementNamed(context, RoutesName.login);
      } else {
        UIHelper.showFlushbarError(context, response['message']);
      }
    } catch (e) {
      UIHelper.showFlushbarError(context, "Signup failed: $e");
    } finally {
      setLoading(false);
    }
  }
  Future<bool> sendOtp(BuildContext context) async {
    if (!_validateForm(forgotFormKey, context, "Enter your email or phone")) return false;
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
        UIHelper.showFlushbarSuccess(context, response['data']['message'] ?? "OTP sent successfully");
        Navigator.pushReplacementNamed(context, RoutesName.pin);
        return true;
      } else {
        UIHelper.showFlushbarError(context, response['message']);
        return false;
      }
    } catch (e) {
      UIHelper.showFlushbarError(context, "Failed to send OTP: $e");
      return false;
    } finally {
      setLoading(false);
    }
  }


  Future<void> verifyOtp(BuildContext context, {int length = 4}) async {
    if (!_validateForm(otpFormKey, context, "Enter a valid $length-digit code")) return;
    if (otpController.text.trim().length != length) {
      UIHelper.showFlushbarError(context, "Enter a valid $length-digit code");
      return;
    }
    if (_resetEmail == null) {
      UIHelper.showFlushbarError(context, "Please request a new PIN first");
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
        UIHelper.showFlushbarSuccess(context, "OTP verified");
        clearControllers();
        Navigator.pushReplacementNamed(context, RoutesName.password);
      } else {
        UIHelper.showFlushbarError(context, response['message']);
      }
    } catch (e) {
      UIHelper.showFlushbarError(context, "OTP verification failed: $e");
    } finally {
      setLoading(false);
    }
  }
  Future<void> setPassword(BuildContext context) async {
    if (!_validateForm(setFormKey, context, "Passwords do not match or are invalid")) return;
    if (!_passwordsMatch(context)) return;
    if (_resetEmail == null || _resetPin == null) {
      UIHelper.showFlushbarError(context, "Please complete verification first");
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
        },
      );

      if (response['success']) {
        UIHelper.showFlushbarSuccess(context, response['data']['message'] ?? "Password reset successful");
        clearControllers();
        _resetEmail = null;
        _resetPin = null;
        Navigator.pushReplacementNamed(context, RoutesName.login);
      } else {
        UIHelper.showFlushbarError(context, response['message']);
      }
    } catch (e) {
      UIHelper.showFlushbarError(context, "Failed to reset password: $e");
    } finally {
      setLoading(false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }
}

