import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant_menu.dart';

class RestaurantMenuService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  /// Fetch public menu items for a specific restaurant
  Future<List<RestaurantMenu>> getPublicMenu({
    required int restaurantId,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/restaurants/$restaurantId/menu/public');

    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        // Decode UTF-8 properly for Vietnamese text
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        if (data is List && data.isNotEmpty) {
          return data.map((e) => RestaurantMenu.fromJson(e)).toList();
        } else {
          return [];
        }
      } else {
        print('Lỗi tải menu nhà hàng: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Lỗi kết nối khi tải menu: $e');
      return [];
    }
  }
}
