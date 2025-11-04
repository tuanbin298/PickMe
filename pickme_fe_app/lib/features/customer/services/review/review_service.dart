import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pickme_fe_app/features/customer/models/review/review.dart';
import 'package:http/http.dart' as http;

class ReviewService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  // Add new feedback
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
        print('Review submitted successfully!');
        print('Sending review body: $body');

        return true;
      } else {
        print('Failed to submit review (${response.statusCode})');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Connection error while sending review: $e');
      return false;
    }
  }

  // Get all reviews of a restaurant
  Future<List<Review>> getRestaurantReviewsByRestaurantId({
    required String token,
    required int restaurantId,
  }) async {
    final url = Uri.parse('$baseUrl/reviews/restaurant/$restaurantId');

    try {
      print('Fetching reviews from: $url');
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

        print('Loaded ${reviews.length} reviews');
        return reviews;
      } else {
        print('Failed to load reviews (${response.statusCode})');
        print('Response: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

  // Get all reviews of the current logged-in user
  Future<List<Review>> getMyReviews({required String token}) async {
    final url = Uri.parse('$baseUrl/reviews/my-reviews');

    try {
      print('Fetching my reviews from: $url');
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print("Response body (my-reviews): $body");

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

        print('Loaded ${reviews.length} of my reviews');
        for (var r in reviews) {
          print(
            "🧩 Review: id=${r.id}, type=${r.reviewType}, restaurantId=${r.restaurantId}, comment=${r.comment}",
          );
        }

        return reviews;
      } else {
        print(' Failed to load my reviews (${response.statusCode})');
        print('Response: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching my reviews: $e');
      return [];
    }
  }
}
