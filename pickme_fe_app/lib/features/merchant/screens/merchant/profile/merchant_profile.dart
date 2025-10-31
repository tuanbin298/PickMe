import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/core/common_widgets/profile/profile_header.dart';
import 'package:pickme_fe_app/core/common_widgets/profile/profile_notification_tile.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/auth/model/user.dart';
import 'package:pickme_fe_app/features/customer/widgets/profile/profile_menu_item.dart';
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

  // Variable for toggle
  bool _notifGeneral = false;
  bool _notifOffers = false;

  // Fecth api to get merchant information
  @override
  void initState() {
    super.initState();
    _futureUser = _merchantService.getMerchant(widget.token);
  }

  // Method logout
  Future<void> _logout() async {
    // Dialog
    final confirm =
        await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Xác nhận'),
            content: const Text('Bạn có chắc muốn đăng xuất?'),
            actions: [
              // Cancel
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Hủy'),
              ),

              // Accept
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Đăng xuất'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirm) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (mounted) {
      context.go("/login");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã đăng xuất')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // App bar
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        surfaceTintColor: Colors.transparent,
        title: const Text("Tài khoản"),
        centerTitle: true,
        elevation: 0,
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
                  /// Header
                  ProfileHeader(name: user.fullName ?? "", avatarUrl: ''),

                  const SizedBox(height: 12),

                  //  Overview section
                  _buildSection(
                    title: "Tổng quan",
                    children: [
                      // Account information
                      ProfileMenuItem(
                        icon: Icons.person_outline,
                        title: "Thông tin tài khoản",
                        subtitle: "Thay đổi thông tin tài khoản",
                        onTap: () {
                          context.push(
                            "/account-information",
                            extra: widget.token,
                          );
                        },
                      ),

                      // Password information
                      ProfileMenuItem(
                        icon: Icons.lock_outline,
                        title: "Mật khẩu",
                        subtitle: "Thay đổi mật khẩu",
                        onTap: () {
                          context.push(
                            "/account-resetpassword",
                            extra: widget.token,
                          );
                        },
                      ),

                      // Payment method information
                      ProfileMenuItem(
                        icon: Icons.credit_card_outlined,
                        title: "Phương thức thanh toán",
                        subtitle: "Thêm thẻ ngân hàng/tín dụng",
                        onTap: () {
                          context.push(
                            "/account-payment-method",
                            extra: widget.token,
                          );
                        },
                      ),

                      // Address information
                      ProfileMenuItem(
                        icon: Icons.location_on_outlined,
                        title: "Địa chỉ",
                        subtitle: "Thay đổi địa chỉ",
                        onTap: () {
                          context.push("/account-address", extra: widget.token);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Notofication section
                  _buildSection(
                    title: "Thông báo",
                    children: [
                      // Toggle notification
                      ProfileNotificationTile(
                        title: "Thông báo chung",
                        subtitle: "Bạn sẽ nhận thông báo từ ứng dụng",
                        value: _notifGeneral,
                        onChanged: (val) {
                          setState(() => _notifGeneral = val);
                        },
                      ),

                      // Toggle offers
                      ProfileNotificationTile(
                        title: "Thông báo ưu đãi",
                        subtitle: "Nhận thông báo khi có ưu đãi mới",
                        value: _notifOffers,
                        onChanged: (val) {
                          setState(() => _notifOffers = val);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Logout button
                  ProfileMenuItem(
                    icon: Icons.logout,
                    title: "Đăng xuất",
                    onTap: _logout,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widgett to build section
  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),

            // Text
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),

          // Content
          ...children,
        ],
      ),
    );
  }
}
