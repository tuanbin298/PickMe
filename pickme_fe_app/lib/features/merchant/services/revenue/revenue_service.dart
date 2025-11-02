import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RevenueService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  // Get restaurant revenue
  Future getRevenueByRestaurantId(String token, int restaurantId) async {
    final url = Uri.parse(
      '$baseUrl/orders/restaurant/$restaurantId/stats/revenue',
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
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      return data;
    } else {
      print('Lỗi tải doanh thu: ${response.statusCode}');
    }
  }
}
