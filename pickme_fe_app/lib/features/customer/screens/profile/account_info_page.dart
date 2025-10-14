import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/customer/services/customer/customer_service.dart';
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
  bool _isEditing = false;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

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

      if (account != null) {
        _nameController = TextEditingController(text: account.fullName ?? '');
        _emailController = TextEditingController(text: account.email ?? '');
        _phoneController = TextEditingController(
          text: account.phoneNumber ?? '',
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải thông tin tài khoản: $e')),
      );
    }
  }

  Future<void> _updateAccountInfo() async {
    if (_account == null) return;

    final updated = AccountModel(
      id: _account!.id,
      email: _emailController.text,
      fullName: _nameController.text,
      phoneNumber: _phoneController.text,
      imageUrl: _account!.imageUrl,
      role: _account!.role,
      isActive: _account!.isActive,
    );

    try {
      setState(() => _isLoading = true);
      final result = await _customerService.updateUser(_account!.id!, updated);

      setState(() {
        _account = result;
        _isEditing = false;
        _isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cập nhật thành công!')));
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Cập nhật thất bại: $e')));
    }
  }

  Widget _buildInfoField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            readOnly: readOnly,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xffF2F3F5),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
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
        actions: [
          if (!_isEditing && !_isLoading)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
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
                    _buildInfoField(
                      'Họ và tên',
                      _nameController,
                      readOnly: !_isEditing,
                    ),
                    _buildInfoField(
                      'Địa chỉ email',
                      _emailController,
                      readOnly: true,
                    ),
                    _buildInfoField(
                      'Số điện thoại',
                      _phoneController,
                      readOnly: !_isEditing,
                    ),

                    const SizedBox(height: 20),

                    if (_isEditing)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _updateAccountInfo,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                              child: const Text(
                                'Lưu thay đổi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  setState(() => _isEditing = false),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                              child: const Text('Hủy'),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
