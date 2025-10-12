import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/auth/model/user.dart';
import 'package:pickme_fe_app/features/merchant/services/merchant/merchant.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MerchantProfile extends StatefulWidget {
  final String token;

  const MerchantProfile({super.key, required this.token});

  @override
  State<MerchantProfile> createState() => _MerchantProfileState();
}

class _MerchantProfileState extends State<MerchantProfile> {
  final MerchantService _merchantService = MerchantService();

  // Variable to contain data from API
  late Future<User?> _futureUser = Future.value(null);

  // Fecth api to get merchant information
  @override
  void initState() {
    super.initState();
    _futureUser = _merchantService.getMerchant(widget.token);
  }

  // Method logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    context.go("/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar
      appBar: AppBar(
        title: const Text(
          'Tài khoản',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),

      body: FutureBuilder<User?>(
        future: _futureUser,
        builder: (context, snapshot) {
          // Waiting to data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
          }

          final user = snapshot.data;
          if (user == null) {
            return const Center(child: Text("Không có thông tin người dùng."));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: const AssetImage(
                      'lib/assets/images/default_avatar.jpg',
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Name
                  Text(
                    user.fullName ?? "Không rõ tên",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Card: Merchant information
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Thông tin cá nhân",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 8),

                          _buildInfoCard(
                            title: "Số điện thoại",
                            value: user.phoneNumber ?? "Chưa có thông tin",
                            icon: Icons.phone_outlined,
                          ),

                          const SizedBox(height: 4),

                          _buildInfoCard(
                            title: "Email",
                            value: user.email ?? "Chưa có thông tin",
                            icon: Icons.email_outlined,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Button logout
                  Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ElevatedButton.icon(
                        onPressed: logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          "Đăng xuất",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Widget buildInfoCar
Widget _buildInfoCard({
  required String title,
  required String value,
  required IconData icon,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: Colors.transparent,
      border: const Border(bottom: BorderSide(color: Colors.grey, width: 0.3)),
    ),
    child: Row(
      children: [
        // Icon
        Icon(icon, color: Colors.orange),

        const SizedBox(width: 10),

        // Expanded contain information
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),

              // Data
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
