import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  /// Send OTP to email
  Future<bool> sendOtp(String email) async {
    final url = Uri.parse('$baseUrl/auth/send-otp');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    return response.statusCode == 200;
  }

  /// Verify OTP
  Future<bool> verifyOtp(String email, String otp) async {
    final url = Uri.parse('$baseUrl/auth/verify-otp');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "otp": otp}),
    );

    return response.statusCode == 200;
  }

  /// Reset Password with OTP
  Future<bool> resetPassword(
    String email,
    String otp,
    String newPassword,
    String confirmPassword,
  ) async {
    final url = Uri.parse('$baseUrl/auth/reset-password-with-otp');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "otp": otp,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
        "passwordsMatch": newPassword == confirmPassword,
      }),
    );

    return response.statusCode == 200;
  }
}
