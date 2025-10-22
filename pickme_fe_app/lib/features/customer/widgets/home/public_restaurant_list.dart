import 'package:flutter/material.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant.dart';
import 'package:pickme_fe_app/features/customer/services/restaurant/restaurant_service.dart';
import 'package:go_router/go_router.dart';

class PublicRestaurantList extends StatefulWidget {
  final String token;
  const PublicRestaurantList({super.key, required this.token});

  @override
  State<PublicRestaurantList> createState() => _PublicRestaurantListState();
}

class _PublicRestaurantListState extends State<PublicRestaurantList> {
  final RestaurantService _restaurantService = RestaurantService();
  List<Restaurant> _restaurants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    try {
      final data = await _restaurantService.getPublicRestaurants();
      if (!mounted) return;
      setState(() {
        _restaurants = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải danh sách quán ăn: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_restaurants.isEmpty) {
      return const Center(
        child: Text(
          'Chưa có quán ăn nào được hiển thị.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _restaurants.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = _restaurants[index];

        final imageUrl = item.imageUrl?.isNotEmpty == true
            ? item.imageUrl!
            : 'https://via.placeholder.com/400x200.png?text=No+Image';

        final name = item.name?.isNotEmpty == true
            ? item.name!
            : 'Không có tên';
        final address = item.address?.isNotEmpty == true
            ? item.address!
            : 'Không có địa chỉ';
        final rating = item.rating ?? 0.0;
        final isOpen = item.isOpen ?? false;
        final isApproved = item.isApproved ?? false;
        final categories =
            (item.categories != null && item.categories!.isNotEmpty)
            ? item.categories!.join(' · ')
            : 'Danh mục chưa cập nhật';

        return GestureDetector(
          onTap: () {
            context.push(
              '/restaurant/${item.id}',
              extra: {
                'restaurant': item,
                'token': widget.token, // nếu có token
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant image
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 140,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Restaurant details
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + verified icon
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff172B4D),
                                ),
                              ),
                            ),
                            if (isApproved)
                              const Icon(
                                Icons.verified,
                                color: Colors.green,
                                size: 18,
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Status + categories
                        Row(
                          children: [
                            Text(
                              isOpen ? 'Đang mở' : 'Đã đóng',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isOpen ? Colors.green : Colors.red,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                categories,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Rating + address
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                address,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
