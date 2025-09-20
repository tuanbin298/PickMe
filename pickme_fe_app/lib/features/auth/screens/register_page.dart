import 'package:flutter/material.dart';
import '../widgets/base_auth_layout.dart';
import '../widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseAuthLayout(
      title: "Đăng ký tài khoản",

      form: const RegisterForm(),

      bottomSection: Column(
        children: [
          TextButton(
            onPressed: () {
              // TODO: Forgot password (optional cho Register)
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
        // TODO: Handle Google login
      },
    );
  }
}
