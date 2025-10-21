import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant.dart';

class RestaurantMarkerDialog extends StatelessWidget {
  final Restaurant restaurant;
  final Function(LatLng destination)? onSelectDestination;

  const RestaurantMarkerDialog({
    super.key,
    required this.restaurant,
    this.onSelectDestination,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Shadow
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // Container
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image restaurant
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  restaurant.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 12),

              // Restaurant name
              Text(
                restaurant.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 6),

              // Restaurant Address
              Row(
                children: [
                  // Icon
                  const Icon(
                    Icons.location_on,
                    color: Colors.redAccent,
                    size: 18,
                  ),

                  const SizedBox(width: 4),

                  // Text
                  Expanded(
                    child: Text(
                      restaurant.address,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Restaurant phone
              Row(
                children: [
                  const Icon(Icons.phone, color: Colors.green, size: 18),

                  const SizedBox(width: 4),

                  Text(
                    restaurant.phoneNumber,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Restaurant description
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.blueAccent,
                    size: 18,
                  ),

                  const SizedBox(width: 4),

                  Expanded(
                    child: Text(
                      restaurant.description ?? "Không có mô tả",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Button section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Button close
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Đóng",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),

                  // Button destination
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      onSelectDestination?.call(
                        LatLng(
                          restaurant.latitude ?? 0,
                          restaurant.longitude ?? 0,
                        ),
                      );
                    },
                    icon: const Icon(Icons.flag, size: 18, color: Colors.white),
                    label: const Text(
                      "Chọn điểm đến",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
