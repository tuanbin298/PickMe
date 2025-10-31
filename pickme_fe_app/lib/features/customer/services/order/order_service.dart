import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pickme_fe_app/features/customer/models/order/order.dart';

class OrderService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  // Future - asynchronous createOrder
  Future<Order?> createOrder(
    String token,
    int cartId,
    Map<String, dynamic> checkoutData,
  ) async {
    final url = Uri.parse('$baseUrl/cart/$cartId/checkout');

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },

      body: jsonEncode(checkoutData),
    );

    if (response.statusCode == 200) {
      // Forces to use UTF-8 encoding to avoid issues with special characters (Vietnamese)
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return Order.fromJson(data);
    } else {
      print("Không thể tạo đơn hàng");
      return null;
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

  // Get active order (only get order not cancel and complete)
  Future<List<Order>> getActiveOrder(String token) async {
    final url = Uri.parse('$baseUrl/orders/my-orders/active');

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

  // Get history order
  Future<List<Order>> getHistoryOrder(String token) async {
    final url = Uri.parse(
      '$baseUrl/orders/my-orders?page=0&size=10&sortBy=createdAt&sortDir=desc',
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
}
