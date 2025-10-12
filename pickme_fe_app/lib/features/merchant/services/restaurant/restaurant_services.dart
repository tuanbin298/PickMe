import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pickme_fe_app/features/merchant/model/restaurant.dart';

class RestaurantServices {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  // Future - asynchronous getRestaurantsByOwner
  Future<List<Restaurant>> getRestaurantsByOwner(String token) async {
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
      // Forces to use UTF-8 encoding to avoid issues with special characters (Vietnamese)
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      // Data return is [ {}, {} ] => have restaurant
      if (data is List && data.isNotEmpty) {
        final restaurants = data.map((e) => Restaurant.fromJson(e)).toList();
        return restaurants;
      } else {
        return [];
      }
    } else {
      // Handle error
      // ignore: avoid_print
      print('Lỗi tải cửa hàng: ${response.statusCode}');
      return [];
    }
  }

  // Future - asynchronous createRestaurantsByOwner
  Future<Restaurant?> createRestaurantsByOwner(
    String token,
    Map<String, dynamic> restaurantData,
  ) async {
    final url = Uri.parse('$baseUrl/restaurants');

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },

      body: jsonEncode(restaurantData),
    );

    if (response.statusCode == 200) {
      // Forces to use UTF-8 encoding to avoid issues with special characters (Vietnamese)
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final restaurant = Restaurant.fromJson(data);

      return restaurant;
    } else {
      // Handle error
      // ignore: avoid_print
      print('Tạo cửa hàng thất bại: ${response.statusCode}');
      return null;
    }
  }
}
