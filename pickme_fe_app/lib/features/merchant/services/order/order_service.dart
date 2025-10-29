import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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
}
