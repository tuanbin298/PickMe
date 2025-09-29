import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/customer/widgets/profile_header.dart';
import 'package:pickme_fe_app/features/customer/widgets/profile_menu_item.dart';
import 'package:pickme_fe_app/features/customer/widgets/profile_notification_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Tài khoản"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Avatar + tên user
            const ProfileHeader(
              name: "Nguyễn Văn A",
              avatarUrl:
                  "https://i.pravatar.cc/300", // demo, sau fetch API thì đổi
            ),

            const SizedBox(height: 16),

            /// Tổng quan
            _buildSection(
              title: "Tổng quan",
              children: [
                ProfileMenuItem(
                  icon: Icons.person_outline,
                  title: "Thông tin tài khoản",
                  subtitle: "Thay đổi thông tin tài khoản",
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.lock_outline,
                  title: "Mật khẩu",
                  subtitle: "Thay đổi mật khẩu",
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.credit_card_outlined,
                  title: "Phương thức thanh toán",
                  subtitle: "Thêm thẻ ngân hàng/tín dụng",
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.location_on_outlined,
                  title: "Địa chỉ",
                  subtitle: "Thay đổi địa chỉ",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Thông báo
            _buildSection(
              title: "Thông báo",
              children: [
                ProfileNotificationTile(
                  title: "Thông báo",
                  subtitle: "Bạn sẽ nhận thông báo từ ứng dụng",
                  value: true,
                  onChanged: (val) {},
                ),
                ProfileNotificationTile(
                  title: "Thông báo ưu đãi",
                  subtitle: "Nhận thông báo khi có ưu đãi mới",
                  value: false,
                  onChanged: (val) {},
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Logout
            ProfileMenuItem(
              icon: Icons.logout,
              title: "Đăng xuất",
              onTap: () {
                // TODO: gọi AuthService.logout()
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
