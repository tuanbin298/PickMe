import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentQrPage extends StatelessWidget {
  final String qrCodeUrl;

  const PaymentQrPage({super.key, required this.qrCodeUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar
      appBar: AppBar(
        title: const Text('Mã QR thanh toán'),
        backgroundColor: Colors.green,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image QR
            Image.network(
              qrCodeUrl,
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),

            // Title
            const Text(
              'Vui lòng quét mã QR để thanh toán đơn hàng của bạn.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 40),

            // Button to navigate
            ElevatedButton(
              onPressed: () {
                context.go("/home-page");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              child: const Text('Quay lại'),
            ),
          ],
        ),
      ),
    );
  }
}
