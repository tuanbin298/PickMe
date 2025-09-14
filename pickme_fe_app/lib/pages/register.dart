import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;
  bool isLoading = false;

  final phoneRegex = RegExp(r'^(84|0[3|5|7|8|9])\d{8}$');

  void handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 1)); // Fake loading
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("fullName", fullNameController.text.trim());
    await prefs.setString("phone", phoneController.text.trim());

    setState(() => isLoading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Đăng ký thành công")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 40),
              Center(
                child: Image.asset(
                  'lib/assets/images/pickme_logo.png',
                  width: 200,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Chào mừng bạn",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              //Full Name
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: "Họ và tên",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Họ và tên không được để trống";
                  } else if (value.trim().length < 2) {
                    return "Họ và tên phải có ít nhất 2 ký tự";
                  } else if (!RegExp(r'^[a-zA-ZÀ-ỹ\s]+$').hasMatch(value)) {
                    return "Họ và tên chỉ được chứa chữ cái và khoảng trắng";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Phone Number
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Số điện thoại",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final trimmed = value?.trim() ?? '';

                  if (trimmed.isEmpty) {
                    return "Số điện thoại không được để trống";
                  }

                  if (!RegExp(r'^(84|0)(3|5|7|8|9)\d{8}$').hasMatch(trimmed)) {
                    return "Số điện thoại không hợp lệ. Ví dụ: 0371234567 hoặc 84901234567";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Password
              TextFormField(
                controller: passwordController,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => showPassword = !showPassword);
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Mật khẩu không được để trống";
                  }

                  if (value.length < 8) {
                    return "Mật khẩu phải có ít nhất 8 ký tự";
                  }

                  if (!value.contains(RegExp(r'[A-Z]'))) {
                    return "Mật khẩu phải chứa ít nhất 1 chữ cái viết hoa (A-Z)";
                  }

                  if (!value.contains(RegExp(r'[a-z]'))) {
                    return "Mật khẩu phải chứa ít nhất 1 chữ cái viết thường (a-z)";
                  }

                  if (!value.contains(RegExp(r'[0-9]'))) {
                    return "Mật khẩu phải chứa ít nhất 1 chữ số (0-9)";
                  }

                  if (!value.contains(
                    RegExp(r'[!@#\$%^&*(),.?":{}|<>_\[\]~\-+=]'),
                  )) {
                    return "Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt (!@#\$...)";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Confirm Password
              TextFormField(
                controller: confirmPasswordController,
                obscureText: !showConfirmPassword,
                decoration: InputDecoration(
                  labelText: "Nhập lại mật khẩu",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(
                        () => showConfirmPassword = !showConfirmPassword,
                      );
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng nhập lại mật khẩu";
                  } else if (value != passwordController.text) {
                    return "Mật khẩu nhập lại không khớp";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Register button
              ElevatedButton(
                onPressed: isLoading ? null : handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xfffc7f20),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  isLoading ? "Đang đăng ký..." : "Đăng ký",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  // TODO: navigate to forgot password
                },
                child: const Text(
                  "Quên mật khẩu?",
                  style: TextStyle(color: Color(0xfffc7f20)),
                ),
              ),

              const Divider(height: 30),
              Text("hoặc", textAlign: TextAlign.center),
              const SizedBox(height: 16),

              // Login by Google
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Login by Google
                  },
                  icon: Image.asset(
                    "lib/assets/logo/google_logo.png",
                    width: 24,
                  ),
                  label: const Text("Đăng nhập bằng Google"),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
