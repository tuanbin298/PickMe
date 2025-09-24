import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/features/auth/model/user.dart';
import 'package:pickme_fe_app/features/auth/services/login_services.dart';
import 'package:pickme_fe_app/core/utils/notification_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // Variable
  bool _obscurePassword = true;

  // Controller to get data from inputs
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Create instance object of LoginServices
  final LoginServices loginServices = LoginServices();

  // Release memory that controller stored
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Mehthod login
  Future<void> submitLogin() async {
    if (formKey.currentState!.validate()) {
      final emailValue = emailController.text;
      final passwordValue = passwordController.text;

      try {
        final User? user = await loginServices.login(emailValue, passwordValue);

        if (user != null) {
          // Login successful
          NotificationService.showSuccess(
            context,
            "Chào mừng bạn đã đến với PickMe!",
          );

          context.push("/register");
        } else {
          // Login failed
          NotificationService.showError(
            context,
            "Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin.",
          );
        }
      } catch (e) {
        NotificationService.showError(context, "Có lỗi xảy ra: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),

          // Phone input
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email",
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            // Validation
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Vui lòng nhập email";
              }

              // Email Regex
              final emailReg = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              );
              if (!emailReg.hasMatch(value)) {
                return "Email không hợp lệ";
              }

              return null;
            },
          ),

          const SizedBox(height: 14),

          // Password input
          TextFormField(
            controller: passwordController,
            obscureText:
                _obscurePassword, // Hide the password / Show the password
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  // Logic to show/hide password
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
              hintText: "Mật khẩu",
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            // Validation
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mật khẩu';
              }
              if (value.length < 6) {
                return 'Mật khẩu phải có ít nhất 6 ký tự';
              }
              return null;
            },
          ),

          const SizedBox(height: 14),

          // Login button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                submitLogin();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffFC7A1F),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Đăng nhập",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 14),
        ],
      ),
    );
  }
}
