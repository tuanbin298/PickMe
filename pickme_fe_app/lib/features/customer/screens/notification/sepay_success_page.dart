import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/core/common_services/utils_method.dart';
import 'package:pickme_fe_app/features/customer/models/payment/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SepaySuccessPage extends StatefulWidget {
  final Payment payment;

  const SepaySuccessPage({super.key, required this.payment});

  @override
  State<SepaySuccessPage> createState() => _SepaySuccessPageState();
}

class _SepaySuccessPageState extends State<SepaySuccessPage> {
  String? _token;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    setState(() {
      _token = token;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      // Appbar
      appBar: AppBar(
        title: const Text(
          'Thanh toán thành công',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Success Icon
              const Icon(Icons.check_circle, color: Colors.green, size: 100),

              const SizedBox(height: 16),

              // Success Message
              const Text(
                'Thanh toán thành công!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi.',
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chi tiết giao dịch',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                    const Divider(height: 20, thickness: 1),

                    // orderQrCode
                    _buildDetailRow(
                      'Mã đơn hàng: ',
                      widget.payment.orderQrCode,
                    ),

                    // transactionId
                    _buildDetailRow(
                      'Mã giao dịch: ',
                      widget.payment.transactionId,
                    ),

                    // amount
                    _buildDetailRow(
                      'Số tiền: ',
                      UtilsMethod.formatMoney(widget.payment.amount ?? 0),
                    ),

                    // paymentMethodDisplayName
                    _buildDetailRow(
                      'Phương thức: ',
                      widget.payment.paymentMethodDisplayName,
                    ),

                    // paymentStatusDisplayName
                    _buildDetailRow(
                      'Trạng thái: ',
                      widget.payment.paymentStatusDisplayName,
                    ),

                    // paidAt
                    if (widget.payment.paidAt != null)
                      _buildDetailRow(
                        'Thời gian thanh toán: ',
                        UtilsMethod.formatDate(widget.payment.paidAt!),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Button navigate to homepage
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go("/home-page", extra: _token);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Quay lại Trang chủ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  // Helper display data one row
  Widget _buildDetailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Label
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Value
          Flexible(
            child: Text(
              value ?? '-',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
