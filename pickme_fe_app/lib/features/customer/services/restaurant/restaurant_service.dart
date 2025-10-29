import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant.dart';

class RestaurantService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  /// Fetch list of public restaurants to display on the homepage
  Future<List<Restaurant>> getPublicRestaurants() async {
    final url = Uri.parse('$baseUrl/restaurants/public');

    try {
      final response = await http.get(
        url,
        headers: {"Accept": "application/json"},
      );

      if (response.statusCode == 200) {
        // Decode UTF-8 data to correctly display Vietnamese characters
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        // Data return is [ {}, {} ] => have restaurant
        if (data is List && data.isNotEmpty) {
          final restaurants = data.map((e) => Restaurant.fromJson(e)).toList();
          return restaurants;
        } else {
          return [];
        }
      } else {
        print('Lỗi tải danh sách nhà hàng public: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Lỗi kết nối khi tải danh sách nhà hàng: $e');
      return [];
    }
  }

  /// Fetch detail of a specific restaurant by ID
  Future<Restaurant?> getRestaurantById({
    required int restaurantId,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/restaurants/public/$restaurantId');

    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        // Decode UTF-8 để hiển thị tiếng Việt chính xác
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        // API trả về 1 object { id, name, ... }
        if (data is Map<String, dynamic>) {
          return Restaurant.fromJson(data);
        } else {
          print('❌ Dữ liệu trả về không đúng định dạng JSON object.');
          return null;
        }
      } else {
        print('❌ Lỗi tải chi tiết nhà hàng (status ${response.statusCode})');
        return null;
      }
    } catch (e) {
      print('⚠️ Lỗi kết nối khi tải chi tiết nhà hàng: $e');
      return null;
    }
  }
}
