
class AppUrl {
  static const String baseUrl = 'http://192.168.0.101:5000/api';

  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String verifyPin = '$baseUrl/auth/verify-pin';
  static const String resetPassword = '$baseUrl/auth/update-password';

  static const String sendMessage = '$baseUrl/chat/send';
  static String getChat(String bookingId) => '$baseUrl/chat/$bookingId';
  static const String notifications = '$baseUrl/notifications';
}

