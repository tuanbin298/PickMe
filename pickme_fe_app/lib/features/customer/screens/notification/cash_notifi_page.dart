import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/core/common_services/utils_method.dart';
import 'package:pickme_fe_app/features/customer/models/payment/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CashNotifiPage extends StatefulWidget {
  final Payment payment;
  const CashNotifiPage({super.key, required this.payment});

  @override
  State<CashNotifiPage> createState() => _CashNotifiPageState();
}

class _CashNotifiPageState extends State<CashNotifiPage> {
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

    final payment = widget.payment;

    return Scaffold(
      // Appbar
      appBar: AppBar(
        title: const Text("Thông tin thanh toán"),
        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // orderQrCode
            _buildRow("Mã thanh toán:", payment.orderQrCode ?? "-"),

            // orderId
            _buildRow("Số đơn hàng:", payment.orderId.toString()),

            // amount
            _buildRow(
              "Số tiền:",
              UtilsMethod.formatMoney(widget.payment.amount ?? 0),
            ),

            // paymentMethodDisplayName
            _buildRow("Phương thức:", payment.paymentMethodDisplayName ?? "-"),

            // Status
            _buildRow("Trạng thái:", payment.paymentStatusDisplayName ?? "-"),

            // transactionId
            _buildRow("Transaction ID:", payment.transactionId ?? "-"),

            const SizedBox(height: 20),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  context.go("/home-page", extra: _token);
                },
                icon: const Icon(Icons.home),
                label: const Text("Quay về trang chủ"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget
  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),

          Expanded(
            flex: 5,
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
