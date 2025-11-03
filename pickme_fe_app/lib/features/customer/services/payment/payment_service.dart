import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pickme_fe_app/features/customer/models/payment/payment.dart';

class PaymentService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  // Future - asynchronous createPayment
  Future<Payment?> createPayment({
    required String token,
    required int orderId,
    required String paymentMethod,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/payments');

      final body = jsonEncode({
        "orderId": orderId,
        "paymentMethod": paymentMethod,
      });

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        return Payment.fromJson(jsonData);
      } else {
        print("Response body: ${response.body}");
        return null;
      }
    } catch (e) {
      print(" Lỗi thanh toán: $e");
      return null;
    }
  }

  // Get payment by id
  Future<Payment?> getPaymentById(String token, int paymentId) async {
    final url = Uri.parse('$baseUrl/payments/$paymentId');

    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        // Decode UTF-8 data to correctly display Vietnamese characters
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        return Payment.fromJson(data);
      } else {
        print('Lỗi tải thông tin thanh toán (status ${response.statusCode})');
        return null;
      }
    } catch (e) {
      print('Lỗi kết nối khi tải thông tin thanh toán: $e');
      return null;
    }
  }
}
