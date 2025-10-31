import 'package:flutter/material.dart';

// Order status
(String text, IconData icon, Color color) mapOrderStatus(String status) {
  switch (status) {
    case "PENDING":
      return ("Chờ xác nhận", Icons.hourglass_empty, Colors.orange);
    case "CONFIRMED":
      return ("Đã xác nhận", Icons.check_circle_outline, Colors.green);
    case "PREPARING":
      return ("Đang chuẩn bị", Icons.restaurant, Colors.blue);
    case "READY":
      return ("Sẵn sàng nhận món", Icons.delivery_dining, Colors.teal);
    case "PICKED_UP":
      return ("Đã lấy món", Icons.shopping_bag_outlined, Colors.indigo);
    case "COMPLETED":
      return ("Hoàn thành", Icons.celebration, Colors.green);
    case "CANCELLED":
      return ("Đã hủy", Icons.cancel, Colors.redAccent);
    default:
      return ("Không xác định", Icons.help_outline, Colors.grey);
  }
}

// Order payment status
(String text, IconData icon, Color color) mapPaymentStatus(String status) {
  switch (status) {
    case "PENDING":
      return ("Chờ thanh toán", Icons.hourglass_bottom, Colors.orange);
    case "PROCESSING":
      return ("Đang xử lý", Icons.sync, Colors.blueGrey);
    case "PAID":
      return ("Đã thanh toán", Icons.payments, Colors.green);
    case "FAILED":
      return ("Thanh toán thất bại", Icons.error_outline, Colors.red);
    case "REFUNDED":
      return ("Đã hoàn tiền", Icons.undo, Colors.purple);
    case "EXPIRED":
      return ("Hết hạn", Icons.schedule, Colors.grey);
    default:
      return ("Không xác định", Icons.help_outline, Colors.grey);
  }
}
