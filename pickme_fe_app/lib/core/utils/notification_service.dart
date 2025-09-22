import 'package:flutter/material.dart';

class NotificationService {
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(context, message, Colors.green[600]!);
  }

  static void showError(BuildContext context, String message) {
    _showSnackBar(context, message, Colors.red[600]!);
  }

  static void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
