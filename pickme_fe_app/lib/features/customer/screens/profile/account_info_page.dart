import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/customer/models/customer.dart';
import 'package:pickme_fe_app/features/customer/services/customer/customer_service.dart';

class AccountInfoPage extends StatefulWidget {
  final String token;

  const AccountInfoPage({super.key, required this.token});

  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  late final CustomerService _customerService = CustomerService();

  // Variable to contain data from API
  late Future<Customer?> _futureCustomer = Future.value(null);

  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  // Get current user
  Future<Customer?> _loadCustomer() async {
    return await _customerService.getCustomer(widget.token);
  }

  // Update user logic
  Future<void> _updateAccountInfo() async {
    final currentCustomer = await _customerService.getCustomer(widget.token);
    final customerData = {
      "email": currentCustomer!.email,
      "fullName": _nameController.text.trim(),
      "phoneNumber": _phoneController.text.trim(),
      "imageUrl": currentCustomer!.imageUrl,
      "role": currentCustomer.role,
      "isActive": currentCustomer.isActive,
    };

    final updatedCustomer = await _customerService.updateCustomer(
      widget.token,
      currentCustomer.id.toString(),
      customerData,
    );

    if (updatedCustomer != null) {
      setState(() {
        _isEditing = false;
        _futureCustomer = Future.value(updatedCustomer);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cập nhật thành công!')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cập nhật thất bại!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      // Appbar
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Thông tin tài khoản',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),

      body: FutureBuilder<Customer?>(
        future: _loadCustomer(),
        builder: (context, snapshot) {
          // Waiting to data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
          }

          final customer = snapshot.data;
          if (customer == null) {
            return const Center(child: Text('Không có thông tin tài khoản'));
          }

          _nameController.text = customer.fullName ?? '';
          _phoneController.text = customer.phoneNumber ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                _buildInfoField(
                  'Họ và tên',
                  _nameController,
                  readOnly: !_isEditing,
                ),

                // Phone
                _buildInfoField(
                  'Số điện thoại',
                  _phoneController,
                  readOnly: !_isEditing,
                ),

                const SizedBox(height: 24),

                // Editing mode
                if (_isEditing)
                  Row(
                    children: [
                      // Button Save
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _updateAccountInfo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
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

                      // Button cancel
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(() => _isEditing = false),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
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
          );
        },
      ),
    );
  }

  // Widget build information field
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
          // Label
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),

          const SizedBox(height: 8),

          // Text field
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
}
