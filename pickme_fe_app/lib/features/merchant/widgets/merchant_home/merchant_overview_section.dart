import 'package:flutter/material.dart';
import 'package:pickme_fe_app/features/merchant/model/restaurant.dart';
import 'package:pickme_fe_app/features/merchant/services/order/order_service.dart';
import 'package:pickme_fe_app/features/merchant/services/restaurant/restaurant_services.dart';

class MerchantOverviewSection extends StatefulWidget {
  final String token;

  const MerchantOverviewSection({super.key, required this.token});

  @override
  State<MerchantOverviewSection> createState() =>
      _MerchantOverviewSectionState();
}

class _MerchantOverviewSectionState extends State<MerchantOverviewSection> {
  final RestaurantServices _restaurantServices = RestaurantServices();
  final OrderService _orderService = OrderService();

  late Future<List<Restaurant>> _futureRestaurants;
  int? _orderCount;

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  // Fetch api to get restaurants owner
  void _loadRestaurants() {
    int totalOrder = 0;

    _futureRestaurants = _restaurantServices.getRestaurantsByOwner(
      widget.token,
    );

    _futureRestaurants.then((restaurants) async {
      // Get order count
      for (var restaurant in restaurants) {
        if (restaurant.id != null) {
          final count = await _orderService.getOrderCount(
            widget.token,
            restaurant.id ?? 0,
          );

          totalOrder += count;

          setState(() {
            _orderCount = totalOrder;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Thông tin",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            FutureBuilder<List<Restaurant>>(
              future: _futureRestaurants,
              builder: (context, snapshot) {
                // Icon when waiting for loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("Lỗi tải dữ liệu: ${snapshot.error}"),
                  );
                }

                return Column(
                  children: [
                    // Total restaurant
                    _buildInfoCard(
                      title: "Tổng số nhà hàng",
                      value: snapshot.data!.length.toString(),
                      icon: Icons.store,
                      color: Colors.green,
                    ),

                    // Total order
                    _buildInfoCard(
                      title: "Tổng số đơn hàng",
                      value: _orderCount.toString(),
                      icon: Icons.receipt_long,
                      color: Colors.orange,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Widget buil information card
Widget _buildInfoCard({
  required String title,
  required String value,
  required IconData icon,
  required Color color,
}) {
  return Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Widget text
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),

            // Widget value
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
