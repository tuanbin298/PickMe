import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/customer/services/customer_service.dart';
import 'package:pickme_fe_app/features/customer/models/account_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountInfoPage extends StatefulWidget {
  const AccountInfoPage({super.key});

  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  final CustomerService _customerService = CustomerService(
    tokenProvider: () async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    },
  );

  AccountModel? _account;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAccountInfo();
  }

  Future<void> _loadAccountInfo() async {
    try {
      final account = await _customerService.getCurrentUser();
      if (!mounted) return;
      setState(() {
        _account = account;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải thông tin tài khoản: $e')),
      );
    }
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xffF2F3F5),
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.infinity,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Thông tin tài khoản',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _account == null
            ? const Center(child: Text('Không có thông tin tài khoản'))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoField('Họ và tên', _account?.fullName ?? ''),
                    _buildInfoField('Địa chỉ email', _account?.email ?? ''),
                    _buildInfoField(
                      'Số điện thoại',
                      _account?.phoneNumber ?? 'Chưa có',
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // 👉 TODO: mở trang chỉnh sửa thông tin (updateAccount)
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        child: const Text(
                          'Thay đổi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
