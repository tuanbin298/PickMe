import 'package:flutter/material.dart';

class AddressesPage extends StatelessWidget {
  final String token;

  const AddressesPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    final TextEditingController addressController = TextEditingController();
    final TextEditingController wardController = TextEditingController();
    final TextEditingController districtController = TextEditingController();
    final TextEditingController cityController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      // Appbar
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Địa chỉ',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text
                const Text(
                  "Địa chỉ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 16),

                // Address
                _buildTextField(
                  label: "Địa chỉ của bạn *",
                  hint: "Nhập địa chỉ của bạn",
                  controller: addressController,
                ),
                const SizedBox(height: 12),

                //Ward
                _buildTextField(
                  label: "Phường/Xã *",
                  hint: "Nhập Phường hoặc Xã của bạn",
                  controller: wardController,
                ),
                const SizedBox(height: 12),

                // Districy
                _buildTextField(
                  label: "Quận/Huyện *",
                  hint: "Nhập Quận hoặc Huyện của bạn",
                  controller: districtController,
                ),
                const SizedBox(height: 12),

                // City
                _buildTextField(
                  label: "Tỉnh/Thành Phố *",
                  hint: "Nhập Tỉnh hoặc Thành phố của bạn",
                  controller: cityController,
                ),
                const SizedBox(height: 24),

                // Confirm button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      //
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffF59E0B),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ],
    );
  }
}
