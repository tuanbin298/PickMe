import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pickme_fe_app/features/customer/models/review/review.dart';

/// Service for Merchant to fetch restaurant reviews
class ReviewService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  /// Get all reviews for a restaurant by restaurantId (Merchant side)
  Future<List<Review>> getReviewsByRestaurantId({
    required String token,
    required int restaurantId,
  }) async {
    final url = Uri.parse('$baseUrl/reviews/restaurant/$restaurantId');

    try {
      print('[Merchant] Fetching reviews for restaurant: $restaurantId');

      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print("[Merchant] Response body: $body");

        List<dynamic> dataList;

        if (body is List) {
          dataList = body;
        } else if (body is Map<String, dynamic>) {
          dataList = (body['data'] ?? body['reviews'] ?? []) as List;
        } else {
          dataList = [];
        }

        final reviews = dataList
            .map((e) => Review.fromJson(e as Map<String, dynamic>))
            .toList();

        print('[Merchant] Loaded ${reviews.length} reviews');
        return reviews;
      } else {
        print('[Merchant] Failed to load reviews (${response.statusCode})');
        print('Response: ${response.body}');
        return [];
      }
    } catch (e) {
      print('[Merchant] Error fetching restaurant reviews: $e');
      return [];
    }
  }
}
