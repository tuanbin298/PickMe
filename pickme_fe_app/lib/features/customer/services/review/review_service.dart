import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pickme_fe_app/features/customer/models/review/review.dart';
import 'package:http/http.dart' as http;

class ReviewService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  // ✅ Add new feedback
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
        print('✅ Review submitted successfully!');
        return true;
      } else {
        print('❌ Failed to submit review (${response.statusCode})');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('⚠️ Connection error while sending review: $e');
      return false;
    }
  }

  // ✅ Get all reviews of a restaurant
  Future<List<Review>> getRestaurantReviewsByRestaurantId({
    required String token,
    required int restaurantId,
  }) async {
    final url = Uri.parse('$baseUrl/reviews/restaurant/$restaurantId');

    try {
      print('📥 Fetching reviews from: $url');
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

        print('✅ Loaded ${reviews.length} reviews');
        return reviews;
      } else {
        print('❌ Failed to load reviews (${response.statusCode})');
        print('Response: ${response.body}');
        return [];
      }
    } catch (e) {
      print('⚠️ Error fetching reviews: $e');
      return [];
    }
  }

  // ✅ Update existing review
  Future<bool> updateReview({
    required String token,
    required int reviewId,
    required Review review,
  }) async {
    final url = Uri.parse('$baseUrl/reviews/$reviewId');
    final body = jsonEncode({
      "overallRating": review.overallRating,
      "comment": review.comment,
      "imageUrls": review.imageUrls,
    });

    try {
      final response = await http.put(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Review updated successfully!');
        return true;
      } else {
        print('❌ Failed to update review (${response.statusCode})');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('⚠️ Connection error while updating review: $e');
      return false;
    }
  }

  // 🗑️ Delete a review
  Future<bool> deleteReview({
    required String token,
    required int reviewId,
  }) async {
    final url = Uri.parse('$baseUrl/reviews/$reviewId');

    try {
      final response = await http.delete(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('🗑️ Review deleted successfully!');
        return true;
      } else {
        print('❌ Failed to delete review (${response.statusCode})');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('⚠️ Error while deleting review: $e');
      return false;
    }
  }

  // 👤 Get all reviews by a specific user (optional)
  Future<List<Review>> getReviewsByUser({
    required String token,
    required int userId,
  }) async {
    final url = Uri.parse('$baseUrl/reviews/user/$userId');

    try {
      print('📥 Fetching user reviews from: $url');
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

        print('✅ User has ${reviews.length} reviews');
        return reviews;
      } else {
        print('❌ Failed to load user reviews (${response.statusCode})');
        print('Response: ${response.body}');
        return [];
      }
    } catch (e) {
      print('⚠️ Error fetching user reviews: $e');
      return [];
    }
  }

  // 🌟 Get all reviews of the current logged-in user
  // 🌟 Get all reviews of the current logged-in user
  Future<List<Review>> getMyReviews({required String token}) async {
    final url = Uri.parse('$baseUrl/reviews/my-reviews');

    try {
      print('📥 Fetching my reviews from: $url');
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print("📦 Response body (my-reviews): $body");

        // ⚙️ Xử lý linh hoạt cho cả 3 trường hợp trả về
        List<dynamic> dataList;
        if (body is List) {
          // Trường hợp API trả trực tiếp danh sách
          dataList = body;
        } else if (body is Map<String, dynamic>) {
          // Trường hợp API trả JSON dạng { "data": [...] } hoặc { "reviews": [...] }
          dataList = (body['data'] ?? body['reviews'] ?? []) as List;
        } else {
          dataList = [];
        }

        final reviews = dataList
            .map((e) => Review.fromJson(e as Map<String, dynamic>))
            .toList();

        print('✅ Loaded ${reviews.length} of my reviews');
        return reviews;
      } else {
        print('❌ Failed to load my reviews (${response.statusCode})');
        print('Response: ${response.body}');
        return [];
      }
    } catch (e) {
      print('⚠️ Error fetching my reviews: $e');
      return [];
    }
  }
}
