import 'package:flutter/material.dart';

class OrderCurrentTab extends StatelessWidget {
  const OrderCurrentTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty, size: 60, color: Colors.orange),

          SizedBox(height: 16),

          Text(
            "Tính năng sẽ ra mắt sớm!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.orange,
            ),
          ),

          SizedBox(height: 8),

          Text(
            "Hiện chưa có đơn hàng nào đang xử lý",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
