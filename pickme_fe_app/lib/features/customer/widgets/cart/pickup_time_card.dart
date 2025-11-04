import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PickupTimeCard extends StatelessWidget {
  final DateTime pickupTime;
  final String closingTime; //  "HH:mm"
  final VoidCallback onAdjust;

  const PickupTimeCard({
    super.key,
    required this.pickupTime,
    required this.closingTime,
    required this.onAdjust,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeFormat = DateFormat('h:mm a');

    // Parse closingTime (String) -> DateTime
    final closingParts = closingTime.split(':');
    final closingHour = int.tryParse(closingParts[0]) ?? 23;
    final closingMinute =
        int.tryParse(closingParts.length > 1 ? closingParts[1] : '0') ?? 0;

    final closingDateTime = DateTime(
      pickupTime.year,
      pickupTime.month,
      pickupTime.day,
      closingHour,
      closingMinute,
    );

    String? warningText;
    Color warningColor = Colors.orange.shade900;
    Color backgroundColor = Colors.orange.shade50;

    // Case
    if (pickupTime.isBefore(now)) {
      // 1. The time to get it is over.
      warningText =
          "Giờ lấy (${timeFormat.format(pickupTime)}) đã qua. Vui lòng chọn thời gian trong tương lai.";
      warningColor = Colors.red.shade900;
      backgroundColor = Colors.red.shade50;
    } else if (pickupTime.isAfter(closingDateTime)) {
      // 2, Pick up time exceeds closing time
      warningText =
          "Giờ lấy (${timeFormat.format(pickupTime)}) đã vượt quá giờ đóng cửa của quán (${timeFormat.format(closingDateTime)}). Vui lòng chọn lại thời gian khác.";
      warningColor = Colors.red.shade900;
      backgroundColor = Colors.red.shade50;
    } else if (pickupTime.difference(now).inMinutes < 15) {
      // 3. Time taken closer to 15 minutes
      warningText =
          "Thời gian lấy phải cách thời gian hiện tại ít nhất 15 phút để cửa hàng có thời gian chuẩn bị món. Vui lòng chọn lại khung giờ sau ${timeFormat.format(now.add(const Duration(minutes: 15)))}.";
      warningColor = Colors.orange.shade900;
      backgroundColor = Colors.orange.shade50;
    }

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

          //Dispaly pick time
          Text(
            timeFormat.format(pickupTime),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),

          const SizedBox(height: 6),

          // Show warning
          if (warningText != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                warningText,
                style: TextStyle(fontSize: 12, color: warningColor),
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
