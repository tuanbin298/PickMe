import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pickme_fe_app/features/merchant/model/restaurant.dart';

class RestaurantServices {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  // Future - asynchronous
  Future<Restaurant?> getRestaurantsByOwner(String token) async {
    final url = Uri.parse('$baseUrl/restaurants/my-restaurants');

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // data return []: dont have restaurant
      if (data is List && data.isEmpty) {
        return null;

        // data return {}: have restaurant
      } else if (data is Map<String, dynamic>) {
        final restaurant = Restaurant.fromJson(data);

        return restaurant;
      }

      return null;
    } else {
      // Handle error
      // ignore: avoid_print
      print('Lỗi tải cửa hàng: ${response.statusCode}');
      return null;
    }
  }
}
