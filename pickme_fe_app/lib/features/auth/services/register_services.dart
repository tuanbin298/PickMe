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

      // Save user info locally if needed
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("registered_user", jsonEncode(data));

      return registeredUser;
    } else {
      // Extract error message from response body if available
      final errorMessage = _extractErrorMessage(response);
      throw Exception(errorMessage);
    }
  }

  /// Helper to extract error message from the response (JSON or plain text)
  String _extractErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body['message'] != null) {
        return body['message'];
      }
      return response.body.toString(); // fallback: raw body as string
    } catch (_) {
      return response.body.toString(); // fallback: not a JSON response
    }
  }
}
