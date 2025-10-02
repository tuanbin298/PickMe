import 'package:flutter/material.dart';
import 'package:pickme_fe_app/features/not_found/empty_placeholder_widget.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Không tìm thấy trang")),
      //  Content
      body: EmptyPlaceholderWidget(),
    );
  }
}
