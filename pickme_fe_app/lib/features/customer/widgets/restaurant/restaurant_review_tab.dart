import 'package:flutter/material.dart';

class RestaurantReviewTab extends StatelessWidget {
  const RestaurantReviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample reviews data
    final List<Map<String, dynamic>> reviews = [
      {
        'name': 'Nguyễn Văn A',
        'rating': 5.0,
        'comment': 'Món ăn rất ngon, giao hàng nhanh và nóng hổi!',
        'date': '20/10/2025',
      },
      {
        'name': 'Trần Thị B',
        'rating': 4.0,
        'comment': 'Phục vụ thân thiện, giá cả hợp lý. Sẽ ủng hộ lần sau!',
        'date': '18/10/2025',
      },
      {
        'name': 'Lê Minh C',
        'rating': 3.5,
        'comment': 'Đồ ăn ổn nhưng giao hơi chậm một chút.',
        'date': '15/10/2025',
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: reviews.length,
      separatorBuilder: (_, __) => const Divider(height: 24),
      itemBuilder: (context, index) {
        final review = reviews[index];
        final String name = review['name'] as String;
        final double rating = review['rating'] as double;
        final String comment = review['comment'] as String;
        final String date = review['date'] as String;

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

                  const SizedBox(height: 6),

                  // Date
                  Text(
                    date,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
