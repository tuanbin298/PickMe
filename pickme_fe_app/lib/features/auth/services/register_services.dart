import 'dart:convert';
import 'package:pickme_fe_app/features/auth/model/user.dart';
import 'package:pickme_fe_app/core/common_widgets/error_messages.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RegisterServices {
  final String baseUrl = dotenv.env['API_URL_USER_SERVICE'] ?? '';

  Future<User?> register(Map<String, dynamic> newUser) async {
    final url = Uri.parse('$baseUrl/Users');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newUser),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      final errorMessage = _extractErrorMessage(response);
      throw Exception(errorMessage);
    }
  }

  String _extractErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body['message'] != null) {
        return ErrorMessages.from(body['message']);
      }
      return ErrorMessages.from(response.body.toString());
    } catch (_) {
      return ErrorMessages.from(response.body.toString());
    }
  }
}
