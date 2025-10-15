import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models/profile/account_model.dart';

typedef TokenProvider = Future<String?> Function();

class CustomerService {
  final http.Client client;
  final String baseUrl;
  final TokenProvider? tokenProvider;

  CustomerService({http.Client? client, String? baseUrl, this.tokenProvider})
    : client = client ?? http.Client(),
      baseUrl = baseUrl ?? (dotenv.env['API_URL'] ?? '');

  Future<Map<String, String>> _headers() async {
    final token = tokenProvider != null ? await tokenProvider!() : null;
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }

  Uri _url(String path) => Uri.parse('$baseUrl$path');

  // ------------------------------------------------------------
  // USER APIs
  // ------------------------------------------------------------

  Future<AccountModel?> getCurrentUser() async {
    final response = await client.get(
      _url('/users/me'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return AccountModel.fromJson(data);
    } else {
      print('Lỗi tải thông tin người dùng: ${response.statusCode}');
      return null;
    }
  }

  Future<AccountModel> updateUser(int id, AccountModel user) async {
    final response = await client.put(
      _url('/users/$id'),
      headers: await _headers(),
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return AccountModel.fromJson(data);
    } else {
      throw Exception('Cập nhật người dùng thất bại: ${response.statusCode}');
    }
  }
}
