import 'package:flutter/material.dart';

class RestaurantFeedbackPage extends StatefulWidget {
  final String restaurantId;
  final String token;

  const RestaurantFeedbackPage({
    super.key,
    required this.restaurantId,
    required this.token,
  });

  @override
  State<RestaurantFeedbackPage> createState() => _RestaurantFeedbackPageState();
}

class _RestaurantFeedbackPageState extends State<RestaurantFeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phản hồi khách hàng')),
      body: const Center(
        child: Text('Danh sách feedback của khách hàng sẽ hiển thị tại đây'),
      ),
    );
  }
}
