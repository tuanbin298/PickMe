import 'package:flutter/material.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant.dart';
import 'package:pickme_fe_app/core/common_services/utils_method.dart';

class RestaurantInfoCard extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantInfoCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    // Format opening and closing time
    final opening = UtilsMethod.formatTime(restaurant.openingTime);
    final closing = UtilsMethod.formatTime(restaurant.closingTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Restaurant Name and Verification icon
        Row(
          children: [
            Expanded(
              child: Text(
                restaurant.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (restaurant.isApproved == true)
              const Icon(Icons.verified, color: Colors.green),
          ],
        ),
        const SizedBox(height: 6),
        // Rating and Operating Hours
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 18),
            const SizedBox(width: 4),
            Text(
              restaurant.rating == 0.0
                  ? 'Chưa có đánh giá'
                  : restaurant.rating.toStringAsFixed(1),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: restaurant.rating == 0.0 ? Colors.grey : Colors.black,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.schedule, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              '$opening - $closing',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // Address
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 16,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                restaurant.address,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Promotion Banner
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: const [
              Icon(Icons.local_offer, color: Colors.orange, size: 18),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Giảm 32.000đ cho đơn từ 200.000đ',
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
