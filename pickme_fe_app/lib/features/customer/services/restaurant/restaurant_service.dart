import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pickme_fe_app/features/merchant/model/restaurant.dart';

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

        // Verify that returned data is a List
        if (data is List) {
          return data.map((e) => Restaurant.fromJson(e)).toList();
        } else {
          print('Dữ liệu trả về không hợp lệ: $data');
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
}
