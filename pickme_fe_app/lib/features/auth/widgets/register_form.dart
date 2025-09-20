import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;
  bool isLoading = false;

  void handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

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
    return Form(
      key: _formKey,

      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Form Fields
          Column(
            children: [
              // Full Name
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: "Họ và tên",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
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

              const SizedBox(height: 16),

              // Phone Number
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Số điện thoại",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                validator: (value) {
                  final trimmed = value?.trim() ?? '';

                  if (trimmed.isEmpty) {
                    return "Số điện thoại không được để trống";
                  }

                  if (!RegExp(r'^(84|0)(3|5|7|8|9)\d{8}$').hasMatch(trimmed)) {
                    return "Số điện thoại không hợp lệ. Ví dụ: 0371234567";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: passwordController,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey[600],
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

              const SizedBox(height: 16),

              // Confirm Password
              TextFormField(
                controller: confirmPasswordController,
                obscureText: !showConfirmPassword,
                decoration: InputDecoration(
                  labelText: "Nhập lại mật khẩu",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      showConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey[600],
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
              const SizedBox(height: 16),
            ],
          ),

          // Bottom Section
          Column(
            children: [
              // Register button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFC7A1F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    isLoading ? "Đang đăng ký..." : "Đăng ký",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
