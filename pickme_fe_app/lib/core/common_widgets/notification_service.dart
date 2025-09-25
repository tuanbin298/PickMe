import 'package:flutter/material.dart';

// A service to show success and error notifications using SnackBar
class NotificationService {
  static void showSuccess(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message,
      icon: Icons.check_circle_outline,
      backgroundColor: Colors.greenAccent,
    );
  }

  static void showError(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message,
      icon: Icons.error_outline,
      backgroundColor: Colors.redAccent,
    );
  }

  static void _showCustomSnackBar(
    BuildContext context,
    String message, {
    required IconData icon,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // hide previous

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
      elevation: 6,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
