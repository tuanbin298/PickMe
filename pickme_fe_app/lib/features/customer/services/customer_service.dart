import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/account_model.dart';
import '../models/address_model.dart';
import '../models/payment_method_model.dart';
import '../models/notification_pref_model.dart';

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

  Future<List<AccountModel>> getAllUsers() async {
    final response = await client.get(
      _url('/users'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      final list = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      return list.map((e) => AccountModel.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi tải danh sách người dùng: ${response.statusCode}');
    }
  }

  Future<AccountModel?> getUserById(int id) async {
    final response = await client.get(
      _url('/users/$id'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return AccountModel.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Lỗi tải người dùng: ${response.statusCode}');
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

  Future<void> deleteUser(int id) async {
    final response = await client.delete(
      _url('/users/$id'),
      headers: await _headers(),
    );
    if (response.statusCode != 204) {
      throw Exception('Xóa người dùng thất bại: ${response.statusCode}');
    }
  }

  // ------------------------------------------------------------
  // CUSTOMER APIs
  // ------------------------------------------------------------

  Future<AccountModel?> fetchAccount() async {
    final response = await client.get(
      _url('/customer/account'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return AccountModel.fromJson(data);
    } else {
      print('Lỗi tải thông tin tài khoản: ${response.statusCode}');
      return null;
    }
  }

  Future<AccountModel?> updateAccount(AccountModel account) async {
    final response = await client.put(
      _url('/customer/account'),
      headers: await _headers(),
      body: jsonEncode(account.toJson()),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return AccountModel.fromJson(data);
    } else {
      print('Cập nhật tài khoản thất bại: ${response.statusCode}');
      return null;
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await client.post(
      _url('/customer/change-password'),
      headers: await _headers(),
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Đổi mật khẩu thất bại: ${response.statusCode}');
    }
  }

  Future<List<PaymentMethodModel>> fetchPaymentMethods() async {
    final response = await client.get(
      _url('/customer/payment-methods'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      final list = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      return list.map((e) => PaymentMethodModel.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi tải phương thức thanh toán: ${response.statusCode}');
    }
  }

  Future<List<AddressModel>> fetchAddresses() async {
    final response = await client.get(
      _url('/customer/addresses'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      final list = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      return list.map((e) => AddressModel.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi tải địa chỉ: ${response.statusCode}');
    }
  }

  Future<AddressModel?> addAddress(AddressModel address) async {
    final response = await client.post(
      _url('/customer/addresses'),
      headers: await _headers(),
      body: jsonEncode(address.toJson()),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return AddressModel.fromJson(data);
    } else {
      print('Thêm địa chỉ thất bại: ${response.statusCode}');
      return null;
    }
  }

  Future<void> updateNotificationPrefs(NotificationPrefModel prefs) async {
    final response = await client.put(
      _url('/customer/notification-prefs'),
      headers: await _headers(),
      body: jsonEncode(prefs.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Cập nhật cài đặt thông báo thất bại: ${response.statusCode}',
      );
    }
  }
}
