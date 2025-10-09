import 'package:flutter/material.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Phương thức thanh toán'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Thêm thẻ mới'),
              onTap: () {
                // TODO: open add card flow
              },
            ),
            const Divider(),
            const ListTile(
              title: Text('Visa **** 4242'),
              subtitle: Text('Hết hạn 12/26'),
            ),
          ],
        ),
      ),
    );
  }
}
