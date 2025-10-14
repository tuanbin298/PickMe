import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pickme_fe_app/features/customer/models/customer.dart';

class CustomerService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  // Get current user
  Future<Customer?> getCustomer(String token) async {
    final url = Uri.parse('$baseUrl/users/me');

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
      final user = Customer.fromJson(data);

      return user;
    } else {
      // Handle error
      // ignore: avoid_print
      print('Lỗi tải thông tin cá nhân: ${response.statusCode}');
      return null;
    }
  }

  // Get current user
  Future<Customer?> updateCustomer(
    String token,
    String customerId,
    Map<String, dynamic> customerData,
  ) async {
    final url = Uri.parse('$baseUrl/users/${customerId}');

    final response = await http.put(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },

      body: jsonEncode(customerData),
    );

    if (response.statusCode == 200) {
      // Forces to use UTF-8 encoding to avoid issues with special characters (Vietnamese)
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final user = Customer.fromJson(data);

      return user;
    } else {
      // Handle error
      // ignore: avoid_print
      print('Lỗi cập nhật thông tin cá nhân: ${response.statusCode}');
      return null;
    }
  }
}
