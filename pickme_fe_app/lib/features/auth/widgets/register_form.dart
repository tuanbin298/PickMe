import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/auth/model/user.dart';
import 'package:pickme_fe_app/features/auth/services/register_services.dart';
import 'package:pickme_fe_app/core/common_widgets/notification_service.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  // Variable
  String selectedRole = 'CUSTOMER';
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool isLoading = false;

  // Controller to get data from inputs
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Create instance object of RegisterServices
  final RegisterServices registerServices = RegisterServices();

  // Method register
  Future<void> handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    // Create new object
    final newUser = {
      "phoneNumber": phoneController.text.trim(),
      "email": emailController.text.trim(),
      "fullName": fullNameController.text.trim(),
      "password": passwordController.text.trim(),
      "imageUrl": "https://example.com/avatar.jpg",
      "role": selectedRole,
    };
    try {
      final User? registeredUser = await registerServices.register(newUser);

      // If user leave this screen then stop logic below
      if (!mounted) return;

      if (registeredUser != null) {
        NotificationService.showSuccess(context, "Đăng ký thành công!");
        context.go("/login");
      } else {
        NotificationService.showError(
          context,
          "Đăng ký thất bại. Vui lòng thử lại.",
        );
      }
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst("Exception: ", "");
      NotificationService.showError(context, message);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Role Selection
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Bạn muốn đăng nhập với vai trò gì?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    // Customer
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => selectedRole = 'CUSTOMER');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: selectedRole == 'CUSTOMER'
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selectedRole == 'CUSTOMER'
                                  ? AppColors.primary
                                  : Colors.grey[300]!,
                              width: selectedRole == 'CUSTOMER' ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.person,
                                size: 32,
                                color: selectedRole == 'CUSTOMER'
                                    ? AppColors.primary
                                    : Colors.grey[600],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Khách hàng",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: selectedRole == 'CUSTOMER'
                                      ? AppColors.primary
                                      : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Restaurant Owner
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => selectedRole = 'RESTAURANT_OWNER');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: selectedRole == 'RESTAURANT_OWNER'
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selectedRole == 'RESTAURANT_OWNER'
                                  ? AppColors.primary
                                  : Colors.grey[300]!,
                              width: selectedRole == 'RESTAURANT_OWNER' ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.store,
                                size: 32,
                                color: selectedRole == 'RESTAURANT_OWNER'
                                    ? AppColors.primary
                                    : Colors.grey[600],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Chủ cửa hàng",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: selectedRole == 'RESTAURANT_OWNER'
                                      ? AppColors.primary
                                      : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Form Fields
          Column(
            children: [
              // Full name
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: fullNameController,
                      decoration: InputDecoration(
                        labelText: "Tên",
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
                      // Validation
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Tên không được để trống";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
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
                // Validation phone
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng nhập số điện thoại";
                  }

                  // Phone Regex
                  final phoneReg = RegExp(r'^(84|0)(3|5|7|8|9)\d{8}$');
                  if (!phoneReg.hasMatch(value)) {
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
                // Validation password
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Mật khẩu không được để trống";
                  }

                  if (value.length < 6) {
                    return "Mật khẩu phải có ít nhất 6 ký tự";
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
                // Validation confirm password
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
                    backgroundColor: AppColors.primary,
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
