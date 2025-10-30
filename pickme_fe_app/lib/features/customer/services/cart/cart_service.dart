import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pickme_fe_app/features/customer/models/cart/cart.dart';

class CartService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  /// 👉 Lấy toàn bộ giỏ hàng của người dùng (mặc định lấy theo user từ token)
  Future<Cart?> getCart(String token) async {
    final url = Uri.parse('$baseUrl/cart');

    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return Cart.fromJson(data);
      } else {
        print('Lỗi tải giỏ hàng: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Lỗi kết nối khi tải giỏ hàng: $e');
      return null;
    }
  }

  /// 👉 Lấy chi tiết giỏ hàng theo ID
  Future<Cart?> getCartById(String token, int cartId) async {
    final url = Uri.parse('$baseUrl/cart/$cartId');

    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return Cart.fromJson(data);
      } else {
        print('Lỗi lấy chi tiết giỏ hàng: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Lỗi kết nối khi lấy chi tiết giỏ hàng: $e');
      return null;
    }
  }

  /// 🛒 Thêm món nhanh vào giỏ (quick-add)
  Future<bool> quickAddToCart({
    required String token,
    required int restaurantId,
    required int menuItemId,
    required int quantity,
  }) async {
    final url = Uri.parse(
      '$baseUrl/cart/quick-add?restaurantId=$restaurantId&menuItemId=$menuItemId&quantity=$quantity',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print('✅ Thêm món nhanh vào giỏ hàng thành công');
        return true;
      } else {
        print('Lỗi thêm món nhanh: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Lỗi kết nối khi thêm món nhanh: $e');
      return false;
    }
  }

  /// 🧾 Thêm món chi tiết vào giỏ (có add-ons, note,...)
  Future<bool> addToCart({
    required String token,
    required int restaurantId,
    required int menuItemId,
    required int quantity,
    String? specialInstructions,
    List<Map<String, dynamic>>? addOns,
  }) async {
    final url = Uri.parse('$baseUrl/cart/add');

    final body = jsonEncode({
      "restaurantId": restaurantId,
      "menuItemId": menuItemId,
      "quantity": quantity,
      "specialInstructions": specialInstructions ?? "",
      "addOns": addOns ?? [],
    });

    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print('✅ Thêm món vào giỏ hàng thành công');
        return true;
      } else {
        print('Lỗi thêm món chi tiết: ${response.statusCode}');
        print('Body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Lỗi kết nối khi thêm món chi tiết: $e');
      return false;
    }
  }

  /// 🧹 Xóa toàn bộ giỏ hàng
  Future<bool> clearCart(String token, int cartId) async {
    final url = Uri.parse('$baseUrl/cart/$cartId/clear');

    try {
      final response = await http.delete(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print('✅ Đã xóa toàn bộ giỏ hàng');
        return true;
      } else {
        print('Lỗi khi xóa giỏ hàng: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Lỗi kết nối khi xóa giỏ hàng: $e');
      return false;
    }
  }

  /// 🗑️ Xóa một item cụ thể trong giỏ
  Future<bool> removeCartItem(String token, int cartId, int itemId) async {
    final url = Uri.parse('$baseUrl/cart/$cartId/items/$itemId');

    try {
      final response = await http.delete(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print('✅ Đã xóa món khỏi giỏ hàng');
        return true;
      } else {
        print('Lỗi xóa món khỏi giỏ: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Lỗi kết nối khi xóa món khỏi giỏ: $e');
      return false;
    }
  }

  /// 🧩 Lấy danh sách AddOns theo MenuItemId
  Future<List<Map<String, dynamic>>> getAddOnsByMenuItem({
    required String token,
    required int menuItemId,
  }) async {
    final url = Uri.parse('$baseUrl/menu-items/$menuItemId/add-ons');

    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        // Trả về danh sách AddOn dưới dạng List<Map>
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        print('Lỗi tải AddOns: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Lỗi kết nối khi tải AddOns: $e');
      return [];
    }
  }

  // Get cart total price for a specific restaurant
  Future<double> getCartTotalPrice({
    required String token,
    required int restaurantId,
  }) async {
    final url = Uri.parse('$baseUrl/cart/total/restaurant/$restaurantId');

    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      } else {
        print('Lỗi lấy tổng số tiền trong giỏ hàng: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Lỗi lấy tổng số tiền trong giỏ hàng: $e');
      return 0;
    }
  }

  /// Get number of items in cart for a specific restaurant
  Future<int> getCartItemCount({
    required String token,
    required int restaurantId,
  }) async {
    final url = Uri.parse('$baseUrl/cart/count/restaurant/$restaurantId');

    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        // API return int
        if (data is int) return data;

        return 0;
      } else {
        print('Lỗi lấy số lượng món trong giỏ: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Lỗi kết nối khi lấy số lượng món trong giỏ: $e');
      return 0;
    }
  }

  /// Lấy danh sách món ăn trong giỏ hàng theo nhà hàng
  // Trong CartService
  Future<Map<String, dynamic>?> getCartByRestaurantId({
    required String token,
    required int restaurantId,
  }) async {
    final url = Uri.parse('$baseUrl/cart/restaurant/$restaurantId');
    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      print("Lỗi API cart: $e");
    }
    return null;
  }
}
