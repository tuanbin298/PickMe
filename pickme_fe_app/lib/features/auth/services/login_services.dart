import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pickme_fe_app/features/auth/model/user.dart';

class LoginServices {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  // Future - asynchronous
  Future<User?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = User.fromJson(data);

      // Save data into SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("email", jsonEncode(user.email));
      await prefs.setString("fullName", jsonEncode(user.fullName));
      await prefs.setString("id", jsonEncode(user.id));
      await prefs.setString("imageUrl", jsonEncode(user.imageUrl));
      await prefs.setString("role", jsonEncode(user.role));
      await prefs.setString("phoneNumber", jsonEncode(user.phoneNumber));
      await prefs.setString("token", user.token ?? "");

      return user;
    } else {
      // Handle error
      // ignore: avoid_print
      print('Đăng nhập thất bại: ${response.statusCode}');
      return null;
    }
  }
}
