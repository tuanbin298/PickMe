import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/customer/models/review/review.dart';
import 'package:pickme_fe_app/features/merchant/services/review/review_service.dart';

class RestaurantFeedbackPage extends StatefulWidget {
  final String token;
  final int restaurantId;

  const RestaurantFeedbackPage({
    super.key,
    required this.token,
    required this.restaurantId,
  });

  @override
  State<RestaurantFeedbackPage> createState() => _RestaurantFeedbackPageState();
}

class _RestaurantFeedbackPageState extends State<RestaurantFeedbackPage> {
  Future<List<Review>>? _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = ReviewService().getReviewsByRestaurantId(
      token: widget.token,
      restaurantId: widget.restaurantId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      // Appbar
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          "Đánh giá khách hàng",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
      ),

      body: FutureBuilder<List<Review>>(
        future: _reviewsFuture,
        builder: (context, snapshot) {
          // loadingg
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Lỗi tải đánh giá: ${snapshot.error}"));
          }

          final reviews = snapshot.data ?? [];

          if (reviews.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.reviews, size: 60, color: Colors.orange),
                  SizedBox(height: 16),
                  Text(
                    "Chưa có đánh giá nào",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              final name = review.reviewerName ?? "Khách hàng";
              final rating = review.overallRating.toDouble();
              final comment = review.comment;
              final date = review.createdAt != null
                  ? DateFormat('dd/MM/yyyy').format(review.createdAt!)
                  : "Không rõ ngày";

              return Card(
                color: Colors.white,
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar user
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, color: Colors.white),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // Rating row
                            Row(
                              children: [
                                Text(
                                  rating.toStringAsFixed(1),
                                  style: TextStyle(
                                    color: Colors.orange.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.star,
                                  size: 18,
                                  color: Colors.orange.shade600,
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Comment
                            Text(comment, style: const TextStyle(fontSize: 14)),

                            const SizedBox(height: 8),

                            // Date
                            Text(
                              date,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),

                            // Owner response
                            // if (review.ownerResponse != null &&
                            //     review.ownerResponse!.isNotEmpty)
                            //   Container(
                            //     margin: const EdgeInsets.only(top: 12),
                            //     padding: const EdgeInsets.all(10),
                            //     decoration: BoxDecoration(
                            //       color: Colors.orange.shade50,
                            //       borderRadius: BorderRadius.circular(8),
                            //       border: Border.all(
                            //         color: Colors.orange.shade200,
                            //       ),
                            //     ),
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         const Text(
                            //           "Phản hồi từ nhà hàng:",
                            //           style: TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 12,
                            //           ),
                            //         ),
                            //         const SizedBox(height: 4),
                            //         Text(
                            //           review.ownerResponse!,
                            //           style: const TextStyle(fontSize: 12),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
