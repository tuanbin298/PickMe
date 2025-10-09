import 'package:flutter/material.dart';

class AddressesPage extends StatelessWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Địa chỉ'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ListTile(
              leading: const Icon(Icons.add_location),
              title: const Text('Thêm địa chỉ mới'),
              onTap: () {
                // TODO: open add address flow
              },
            ),
            const Divider(),
            const ListTile(
              title: Text('Nhà riêng'),
              subtitle: Text('Số 1, Đường A, Quận X'),
            ),
          ],
        ),
      ),
    );
  }
}
