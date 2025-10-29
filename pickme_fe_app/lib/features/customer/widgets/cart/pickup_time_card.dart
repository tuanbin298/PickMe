import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PickupTimeCard extends StatelessWidget {
  final DateTime pickupTime;
  final VoidCallback onAdjust;

  const PickupTimeCard({
    super.key,
    required this.pickupTime,
    required this.onAdjust,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Thời gian lấy",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              TextButton(onPressed: onAdjust, child: const Text("Điều chỉnh")),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            DateFormat('h:mm a').format(pickupTime),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Hiện tại khung giờ ${DateFormat('h:mm a').format(pickupTime)} đã gần giờ lấy, hãy liên hệ trước khi đến quán để người bán chuẩn bị món nhé.",
              style: TextStyle(fontSize: 12, color: Colors.orange.shade900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}
