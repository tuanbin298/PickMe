import 'package:flutter/material.dart';
import 'package:pickme_fe_app/features/auth/model/user.dart';
import 'package:pickme_fe_app/features/auth/screens/register_page.dart';
import 'package:pickme_fe_app/features/auth/services/login_services.dart';

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
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Create instance object of LoginServices
  final LoginServices loginServices = LoginServices();

  // Release memory that controller stored
  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Mehthod login
  Future<void> submitLogin() async {
    if (formKey.currentState!.validate()) {
      final phoneValue = phoneController.text;
      final passwordValue = passwordController.text;

      final User? user = await loginServices.login(phoneValue, passwordValue);

      if (user != null) {
        // Login successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Chào mừng bạn đã đến với PickMe!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        // Ví dụ: chuyển sang màn hình HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RegisterPage()),
        );
      } else {
        // Login failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Sai tài khoản hoặc mật khẩu!",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          ),
        );
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
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Số điện thoại",
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
                return "Vui lòng nhập số điên thoại";
              }

              // Viet Nam phone Regex
              final phoneReg = RegExp(r'^(0|\+84)[0-9]{9}$');
              if (!phoneReg.hasMatch(value)) {
                return "Số điện thoại không hợp lệ";
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
