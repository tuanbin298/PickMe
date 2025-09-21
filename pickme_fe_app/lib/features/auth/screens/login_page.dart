import 'package:flutter/material.dart';
import '../widgets/base_auth_layout.dart';
import '../widgets/login_form.dart';
import 'register_page.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/auth/screens/forgot_password_page.dart';

class AuthSwitchText extends StatelessWidget {
  final String label;
  final String actionLabel;
  final VoidCallback onTap;

  const AuthSwitchText({
    super.key,
    required this.label,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            actionLabel,
            style: const TextStyle(fontSize: 16, color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseAuthLayout(
      title: "Chào mừng bạn",
      subtitle: "Đăng nhập để tiếp tục",
      topSection: AuthSwitchText(
        label: "Hoặc",
        actionLabel: "Tạo tài khoản",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegisterPage()),
          );
        },
      ),
      form: const LoginForm(),
      bottomSection: Column(
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
              );
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
