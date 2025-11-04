import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickme_fe_app/features/customer/models/review/review.dart';
import 'package:pickme_fe_app/features/customer/services/review/review_service.dart';

class RestaurantReviewTab extends StatefulWidget {
  final String token;
  final int restaurantId;

  const RestaurantReviewTab({
    super.key,
    required this.token,
    required this.restaurantId,
  });

  @override
  State<RestaurantReviewTab> createState() => _RestaurantReviewTabState();
}

class _RestaurantReviewTabState extends State<RestaurantReviewTab> {
  late Future<List<Review>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = ReviewService().getRestaurantReviewsByRestaurantId(
      token: widget.token,
      restaurantId: widget.restaurantId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Review>>(
      future: _reviewsFuture,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Lỗi khi tải đánh giá: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final reviews = snapshot.data ?? [];

        // Empty state
        if (reviews.isEmpty) {
          return const Center(
            child: Text(
              'Chưa có đánh giá nào cho nhà hàng này.',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          );
        }

        // List of reviews
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: reviews.length,
          separatorBuilder: (_, __) => const Divider(height: 24),
          itemBuilder: (context, index) {
            final review = reviews[index];
            final String name = review.id != null
                ? 'Người dùng #${review.id}'
                : 'Người dùng ẩn danh';
            final double rating = review.overallRating.toDouble();
            final String comment = review.comment;
            final String date = review.createdAt != null
                ? DateFormat('dd/MM/yyyy').format(review.createdAt!)
                : 'Không rõ ngày';

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Avatar
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),

                // Review Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Name
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),

                          // Rating
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber.shade600,
                                size: 18,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Comment
                      Text(comment, style: const TextStyle(fontSize: 14)),

                      if (review.imageUrls.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: review.imageUrls.map((url) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                url,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 24,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],

                      const SizedBox(height: 6),

                      // Date
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
