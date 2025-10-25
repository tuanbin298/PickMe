import 'package:flutter/material.dart';
import '../../models/order/order.dart';
import 'order_card.dart';

class OrderHistoryTab extends StatelessWidget {
  final Future<List<OrderModel>> ordersFuture;
  const OrderHistoryTab({super.key, required this.ordersFuture});

  @override
  Widget build(BuildContext context) {
    // Build order history list
    return FutureBuilder<List<OrderModel>>(
      future: ordersFuture,
      builder: (context, snapshot) {
        // Loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // Error handling
        if (snapshot.hasError) {
          return Center(child: Text('Lỗi tải đơn hàng: ${snapshot.error}'));
        }
        // Display orders
        final orders = snapshot.data ?? [];
        // No orders message
        if (orders.isEmpty) {
          return const Center(child: Text('Chưa có đơn hàng nào'));
        }
        // Orders list
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: orders.length,
          itemBuilder: (context, i) => OrderCard(order: orders[i]),
        );
      },
    );
  }
}
