import 'package:flutter/material.dart';

class AccountInfoPage extends StatelessWidget {
  const AccountInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Thông tin tài khoản'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ListTile(
                title: Text('Họ và tên'),
                subtitle: Text('Nguyễn Văn A'),
              ),
              const Divider(),
              const ListTile(
                title: Text('Email'),
                subtitle: Text('a@example.com'),
              ),
              const Divider(),
              ElevatedButton(
                onPressed: () {
                  // TODO: open edit form connected to domain use-case
                },
                child: const Text('Chỉnh sửa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
