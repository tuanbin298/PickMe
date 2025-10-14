import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pickme_fe_app/features/merchant/model/menu.dart';

class MenuServices {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  // Future - asynchronous getMenu
  Future<List<Menu>> getMenu(String token, String restaurantId) async {
    final url = Uri.parse('$baseUrl/restaurants/${restaurantId}/menu');

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

      // Data return is [ {}, {} ] => have menu
      if (data is List && data.isNotEmpty) {
        final menuList = data.map((e) => Menu.fromJson(e)).toList();
        return menuList;
      } else {
        return [];
      }
    } else {
      // Handle error
      // ignore: avoid_print
      print('Lỗi tải menu: ${response.statusCode}');
      return [];
    }
  }

  // Future - asynchronous createMenu
  Future<Menu?> createMenu(
    String token,
    String restaurantId,
    Map<String, dynamic> menuData,
  ) async {
    final url = Uri.parse('$baseUrl/restaurants/${restaurantId}/menu');

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },

      body: jsonEncode(menuData),
    );

    if (response.statusCode == 200) {
      // Forces to use UTF-8 encoding to avoid issues with special characters (Vietnamese)
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final menu = Menu.fromJson(data);

      return menu;
    } else {
      // Handle error
      // ignore: avoid_print
      print('Tạo menu thất bại: ${response.statusCode}');
      return null;
    }
  }
}
