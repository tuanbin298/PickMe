import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pickme_fe_app/features/merchant/model/order.dart';

class OrderService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  // Future - asynchronous getOrderCount
  Future<int> getOrderCount(String token, int restaurantId) async {
    final url = Uri.parse(
      '$baseUrl/orders/restaurant/${restaurantId}/stats/count',
    );

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = utf8.decode(response.bodyBytes);

      return int.parse(data);
    } else {
      return 0;
    }
  }

  // Get All Orders Of Restaurant
  Future<List<Order>> getAllOrdersOfRestaurant(
    String token,
    int restaurantId,
  ) async {
    final url = Uri.parse(
      '$baseUrl/orders/restaurant/$restaurantId?page=0&size=10&sortBy=createdAt&sortDir=desc',
    );

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      // Forces to use UTF-8 encoding to avoid issues with special characters (Vietnamese)
      final data = jsonDecode(utf8.decode(response.bodyBytes))['content'];

      if (data is List) {
        return data.map((e) => Order.fromJson(e)).toList();
      } else {
        return [];
      }
    } else {
      print("Không thể lấy thông tin đơn hàng");
      return [];
    }
  }

  // Get Order and order items by ID
  Future<Order?> getOrderById(String token, int orderId) async {
    final url = Uri.parse('$baseUrl/orders/$orderId');

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      // Forces to use UTF-8 encoding to avoid issues with special characters (Vietnamese)
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return Order.fromJson(data);
    } else {
      print("Không thể lấy thông tin đơn hàng");
      return null;
    }
  }

  // Method update order status
  Future<Order?> updateOrderStatus(
    String token,
    int orderId,
    String orderStatus,
  ) async {
    final url = Uri.parse(
      '$baseUrl/orders/$orderId/status?status=$orderStatus',
    );

    final response = await http.put(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },

      body: jsonEncode({"status": orderStatus}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return Order.fromJson(data);
    } else {
      print("Cập nhật trạng thái thất bại: ${response.body}");
      return null;
    }
  }
}
