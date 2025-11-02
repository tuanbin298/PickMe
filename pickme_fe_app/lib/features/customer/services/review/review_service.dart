import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pickme_fe_app/features/customer/models/review/review.dart';
import 'package:http/http.dart' as http;

class ReviewService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  Future<bool> addRestaurantReview({
    required String token,
    required Review review,
  }) async {
    final url = Uri.parse('$baseUrl/reviews/restaurant/${review.restaurantId}');

    final body = jsonEncode({
      "orderId": review.orderId,
      "overallRating": review.overallRating,
      "comment": review.comment,
      "imageUrls": review.imageUrls,
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(' Review submitted successfully!');
        return true;
      } else {
        print(' Failed to submit review');
        return false;
      }
    } catch (e) {
      print(' Connection error while sending review: $e');
      return false;
    }
  }

  Future<List<Review>> getRestaurantReviewsByRestaurantId({
    required String token,
    required int restaurantId,
  }) async {
    final url = Uri.parse('$baseUrl/reviews/restaurant/$restaurantId');

    try {
      print(' Fetching reviews from: $url');
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final reviews =
            (data['reviews'] as List<dynamic>?)
                ?.map((e) => Review.fromJson(e))
                .toList() ??
            [];

        return reviews;
      } else {
        print(' Failed to load reviews (${response.statusCode})');
        return [];
      }
    } catch (e) {
      print(' Error fetching reviews: $e');
      return [];
    }
  }
}
