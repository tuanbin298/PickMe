import 'package:flutter/material.dart';
import 'package:pickme_fe_app/features/customer/widgets/profile/profile_header.dart';
import 'package:pickme_fe_app/features/customer/widgets/profile/profile_menu_item.dart';
import 'package:pickme_fe_app/features/customer/widgets/profile/profile_notification_tile.dart';
import 'package:pickme_fe_app/features/customer/screens/profile/account_info_page.dart';
import 'package:pickme_fe_app/features/customer/screens/profile/change_password_page.dart';
import 'package:pickme_fe_app/features/customer/screens/profile/payment_methods_page.dart';
import 'package:pickme_fe_app/features/customer/screens/profile/addresses_page.dart';
import 'package:pickme_fe_app/features/customer/models/profile/account_model.dart';
import 'package:pickme_fe_app/features/customer/services/customer/customer_service.dart';
import 'package:pickme_fe_app/features/auth/services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String token; // ✅ Thêm token để nhận từ ShellRoute
  const ProfilePage({super.key, required this.token});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _userService = UserServices();
  late final CustomerService _customerService;

  AccountModel? _account;
  bool _notifGeneral = true;
  bool _notifOffers = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _customerService = CustomerService(tokenProvider: () async => widget.token);
    print("🧩 Token khi vào ProfilePage: ${widget.token}");
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final acc = await _customerService.getCurrentUser();
      setState(() {
        _account = acc;
        _notifGeneral = true;
        _notifOffers = false;
        _loading = false;
      });
    } catch (e) {
      debugPrint('⚠️ Lỗi tải thông tin người dùng: $e');
      setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    final confirm =
        await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Xác nhận'),
            content: const Text('Bạn có chắc muốn đăng xuất?'),
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

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (r) => false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã đăng xuất')));
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
                    avatarUrl: _account?.imageUrl,
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
                        },
                      ),
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

                  /// Logout
                  ProfileMenuItem(
                    icon: Icons.logout,
                    title: "Đăng xuất",
                    onTap: _logout,
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
