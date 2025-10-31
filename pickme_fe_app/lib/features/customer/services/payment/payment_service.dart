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
}
