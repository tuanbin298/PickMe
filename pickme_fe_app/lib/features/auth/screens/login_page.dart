import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/base_auth_layout.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseAuthLayout(
      // Tittle and subtitle
      title: "Chào mừng bạn",
      subtitle: "Đăng nhập để tiếp tục",

      // Top section with "Or" and "Create Account"
      topSection: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Hoặc",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          TextButton(
            onPressed: () {
              context.push("/register");
            },
            child: const Text(
              "Tạo tài khoản",
              style: TextStyle(fontSize: 16, color: Colors.orange),
            ),
          ),
        ],
      ),

      // Form login
      form: const LoginForm(),

      // Bottom section with "Forgot Password"
      bottomSection: Column(
        children: [
          TextButton(
            onPressed: () {
              // context.push("/forgot-password");
            },
            child: const Text(
              "Quên mật khẩu?",
              style: TextStyle(color: Colors.orange),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
      showGoogleButton: true,
      onGooglePressed: () {
        // Logic for Google Sign-In
      },
    );
  }
}
