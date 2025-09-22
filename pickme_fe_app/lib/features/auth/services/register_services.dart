import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pickme_fe_app/features/auth/model/registered_user.dart';

class RegisterServices {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  Future<RegisteredUser?> register({
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String role,
  }) async {
    final url = Uri.parse('$baseUrl/Users');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'password': password,
        'role': role,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final registeredUser = RegisteredUser.fromJson(data);

      // Lưu thông tin user đã đăng ký (nếu cần)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("registered_user", jsonEncode(data));

      return registeredUser;
    } else {
      print('Đăng ký thất bại: ${response.statusCode}');
      print('Response: ${response.body}');
      return null;
    }
  }
}
