import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UIHelper {
  static void showErrorSnackBar(BuildContext context, String message) {
    _showSnackBar(context, message, backgroundColor: Colors.red);
  }
  static void showSuccessSnackBar(BuildContext context, String message) {
    _showSnackBar(context, message, backgroundColor: Colors.green);
  }
  static void showInfoSnackBar(BuildContext context, String message) {
    _showSnackBar(context, message, backgroundColor: Colors.blue);
  }
  static void _showSnackBar(BuildContext context, String message, {Color backgroundColor = Colors.black}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }


  static void showFlushbarError(BuildContext context, String message) {
    _showFlushbar(context, message, backgroundColor: Colors.red, icon: Icons.error);
  }
  static void showFlushbarSuccess(BuildContext context, String message) {
    _showFlushbar(context, message, backgroundColor: Colors.green, icon: Icons.check_circle);
  }
  static void showFlushbarInfo(BuildContext context, String message) {
    _showFlushbar(context, message, backgroundColor: Colors.blue, icon: Icons.info_outline);
  }
  static void _showFlushbar(
      BuildContext context,
      String message, {
        required Color backgroundColor,
        required IconData icon,
      }) {
    Flushbar(
      message: message,
      icon: Icon(icon, color: Colors.white),
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }


  static void showToast(String message, {Color bgColor = Colors.black, Color textColor = Colors.white}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: bgColor,
      textColor: textColor,
      fontSize: 14.0,
    );
  }


  static Future<void> showErrorDialog(BuildContext context, String title, String message) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

