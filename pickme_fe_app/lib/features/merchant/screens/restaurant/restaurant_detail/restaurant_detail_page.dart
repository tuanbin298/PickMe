import 'package:flutter/material.dart';
import 'package:pickme_fe_app/features/merchant/model/restaurant.dart';
import 'package:pickme_fe_app/features/merchant/screens/restaurant/restaurant_detail/restaurant_menu_page.dart';
import 'package:pickme_fe_app/features/merchant/services/restaurant/restaurant_services.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;
  final String token;

  const RestaurantDetailPage({
    super.key,
    required this.restaurantId,
    required this.token,
  });

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  final RestaurantServices _restaurantServices = RestaurantServices();

  Restaurant? _restaurant;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRestaurantDetail();
  }

  // Fetch api to get restaurant detail
  Future<void> _fetchRestaurantDetail() async {
    final restaurant = await _restaurantServices.getRestaurantDetails(
      widget.token,
      widget.restaurantId,
    );

    setState(() {
      _restaurant = restaurant;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _restaurant == null
          ? const Center(child: Text("Không tìm thấy cửa hàng"))
          : SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant Image
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      child: Image.network(
                        _restaurant!.imageUrl ?? '',
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        // Error when open image
                        errorBuilder: (context, _, __) => Container(
                          height: 220,
                          color: Colors.grey[300],
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 48,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Restaurant information
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Restaurant name
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _restaurant!.name ?? "Không có tên ",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              const Icon(
                                Icons.verified,
                                color: Colors.green,
                                size: 20,
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          // Address
                          Row(
                            children: [
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _restaurant!.address ?? "Không có địa chỉ ",
                                  style: const TextStyle(color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  maxLines: 4,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Restaurant time
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 18,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Giờ mở cửa: ${_restaurant!.openingTime ?? "N/A"} - ${_restaurant!.closingTime ?? "N/A"}",
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Restaurant rating
                          Row(
                            children: [
                              _buildInfoChip(
                                icon: Icons.star,
                                text: _restaurant!.rating.toString(),
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Button manage menu
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                // Điều hướng đến trang quản lý menu
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.orange),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              child: const Text(
                                "Quản lý Menu",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Title + Add button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Title
                              const Text(
                                "Danh sách món ăn",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // Button
                              IconButton(
                                onPressed: () async {
                                  final result = await Navigator.pushNamed(
                                    context,
                                    "/merchant/restaurant/${widget.restaurantId}/create-menu",
                                    arguments: widget.token,
                                  );

                                  if (result == true) {
                                    setState(() {});
                                  }
                                },
                                icon: const Icon(
                                  Icons.add_circle_rounded,
                                  color: Colors.orange,
                                  size: 30,
                                ),
                                tooltip: "Thêm món ăn",
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Call to menu ui
                          RestaurantMenuPage(
                            restaurantId: widget.restaurantId,
                            token: widget.token,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Widget build information chip
  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    Color color = Colors.grey,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Icon
          Icon(icon, color: color, size: 16),

          const SizedBox(width: 4),

          // Text
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
