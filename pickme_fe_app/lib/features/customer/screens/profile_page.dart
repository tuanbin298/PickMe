import 'package:flutter/material.dart';
import 'package:pickme_fe_app/features/customer/widgets/profile_header.dart';
import 'package:pickme_fe_app/features/customer/widgets/profile_menu_item.dart';
import 'package:pickme_fe_app/features/customer/widgets/profile_notification_tile.dart';
import '../widgets/custom_bottom_nav.dart';

import 'package:pickme_fe_app/features/customer/screens/account_info_page.dart';
import 'package:pickme_fe_app/features/customer/screens/change_password_page.dart';
import 'package:pickme_fe_app/features/customer/screens/payment_methods_page.dart';
import 'package:pickme_fe_app/features/customer/screens/addresses_page.dart';
import 'package:pickme_fe_app/features/auth/services/auth_service.dart';
import 'package:pickme_fe_app/features/customer/models/account_model.dart';
import 'package:pickme_fe_app/features/customer/services/customer_service.dart';
import 'package:pickme_fe_app/features/customer/models/notification_pref_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _customerService = CustomerService(
    tokenProvider: () async => await AuthService.instance.getToken(),
  );

  AccountModel? _account;
  bool _notifGeneral = true;
  bool _notifOffers = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  /// 🔹 Gọi API lấy thông tin current user
  Future<void> _loadProfile() async {
    try {
      final acc = await _customerService.getCurrentUser();
      setState(() {
        _account = acc;

        // Nếu API trả về preference, bạn có thể gán thật:
        // _notifGeneral = acc.notificationEnabled ?? true;
        // _notifOffers = acc.promoEnabled ?? false;
        _notifGeneral = true;
        _notifOffers = false;

        _loading = false;
      });
    } catch (e) {
      debugPrint('⚠️ Lỗi tải thông tin người dùng: $e');
      setState(() => _loading = false);
    }
  }

  /// 🔹 Cập nhật thông báo
  Future<void> _updateNotificationPrefs() async {
    try {
      final prefs = NotificationPrefModel(
        general: _notifGeneral,
        offers: _notifOffers,
      );
      await _customerService.updateNotificationPrefs(prefs);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã cập nhật cài đặt thông báo')),
        );
      }
    } catch (e) {
      debugPrint('⚠️ Lỗi cập nhật thông báo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text("Tài khoản"),
        centerTitle: true,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  /// Header
                  ProfileHeader(
                    name: _account?.fullName ?? "Không rõ",
                    avatarUrl:
                        _account?.imageUrl ?? "https://i.pravatar.cc/300?img=5",
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
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AccountInfoPage(),
                            ),
                          );
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.lock_outline,
                        title: "Mật khẩu",
                        subtitle: "Thay đổi mật khẩu",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ChangePasswordPage(),
                            ),
                          );
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.credit_card_outlined,
                        title: "Phương thức thanh toán",
                        subtitle: "Thêm thẻ ngân hàng/tín dụng",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const PaymentMethodsPage(),
                            ),
                          );
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.location_on_outlined,
                        title: "Địa chỉ",
                        subtitle: "Thay đổi địa chỉ",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AddressesPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Thông báo
                  _buildSection(
                    title: "Thông báo",
                    children: [
                      ProfileNotificationTile(
                        title: "Thông báo chung",
                        subtitle: "Bạn sẽ nhận thông báo từ ứng dụng",
                        value: _notifGeneral,
                        onChanged: (val) {
                          setState(() => _notifGeneral = val);
                          _updateNotificationPrefs();
                        },
                      ),
                      ProfileNotificationTile(
                        title: "Thông báo ưu đãi",
                        subtitle: "Nhận thông báo khi có ưu đãi mới",
                        value: _notifOffers,
                        onChanged: (val) {
                          setState(() => _notifOffers = val);
                          _updateNotificationPrefs();
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Logout
                  ProfileMenuItem(
                    icon: Icons.logout,
                    title: "Đăng xuất",
                    onTap: () async {
                      final confirm =
                          await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Xác nhận'),
                              content: const Text(
                                'Bạn có chắc muốn đăng xuất?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('Hủy'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: const Text('Đăng xuất'),
                                ),
                              ],
                            ),
                          ) ??
                          false;

                      if (!confirm) return;

                      await AuthService.instance.logout();
                      if (context.mounted) {
                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil('/login', (r) => false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đã đăng xuất')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: 2,
        onItemSelected: (_) {},
      ),
    );
  }

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
