import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/merchant/model/restaurant.dart';
import 'package:pickme_fe_app/features/merchant/services/restaurant/restaurant_services.dart';

class MerchantRestaurantList extends StatefulWidget {
  final String token;

  const MerchantRestaurantList({super.key, required this.token});

  @override
  State<MerchantRestaurantList> createState() => _MerchantRestaurantListState();
}

class _MerchantRestaurantListState extends State<MerchantRestaurantList> {
  final RestaurantServices _restaurantServices = RestaurantServices();
  late Future<List<Restaurant>> _futureRestaurants;

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  // Fetch api to get restaurants owner
  void _loadRestaurants() {
    _futureRestaurants = _restaurantServices.getRestaurantsByOwner(
      widget.token,
    );
  }

  // Method build status snack bar
  void _showStatusSnackBar(BuildContext context, String status) {
    Color snackColor;
    String message;

    switch (status) {
      // case 'APPROVED':
      //   snackColor = Colors.green.shade600;
      //   message = "Cửa hàng đã được phê duyệt.";
      //   break;
      case 'REJECTED':
        snackColor = Colors.red.shade600;
        message = "Cửa hàng đã bị từ chối. Vui lòng liên hệ quản trị viên.";
        break;
      case 'PENDING':
        snackColor = Colors.orange.shade700;
        message = "Cửa hàng đang chờ duyệt, vui lòng quay lại sau.";
        break;
      default:
        snackColor = Colors.grey.shade700;
        message = "Trạng thái không xác định.";
    }

    // Return ScaffoldMessenger
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: snackColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar
      appBar: AppBar(
        title: const Text(
          'Danh sách cửa hàng',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              final result = await context.push(
                "/merchant-create-resaurant",
                extra: widget.token,
              );

              //If result == true reload screen
              if (result == true) {
                setState(() {
                  _loadRestaurants();
                });
              }
            },
          ),
        ],
      ),

      body: FutureBuilder<List<Restaurant>>(
        future: _futureRestaurants,
        builder: (context, snapshot) {
          // Icon when waiting for loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
          }

          final restaurants = snapshot.data;

          // If merchant dont have restaurant
          if (restaurants == null || restaurants.isEmpty) {
            // Empty restaurant
            return _buildEmptyRestaurantView(context);
          } else {
            // Restaurant list
            return _buildRestaurantListView(context, restaurants);
          }
        },
      ),
    );
  }

  // Widget emty restaurant view
  Widget _buildEmptyRestaurantView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image logo
            Image.asset('lib/assets/images/pickme_logo.png', width: 250),

            const SizedBox(height: 40),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    const Text(
                      "Hoàn tất hồ sơ của bạn!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    const Text(
                      "Hãy tạo quán ăn của riêng bạn và bắt đầu bán ngay hôm nay!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget restaurant list view
  Widget _buildRestaurantListView(
    BuildContext context,
    List<Restaurant> restaurants,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        final restaurantStatus = restaurant.approvalStatus ?? '';

        Color statusColor;
        IconData statusIcon;
        String statusText;

        // Restaurant stauts switch case
        switch (restaurantStatus.toUpperCase()) {
          case 'PENDING':
            statusColor = Colors.orange;
            statusIcon = Icons.hourglass_empty;
            statusText = 'Đang chờ duyệt';
            break;
          case 'APPROVED':
            statusColor = Colors.green;
            statusIcon = Icons.check_circle;
            statusText = 'Đã duyệt';
            break;
          case 'REJECTED':
            statusColor = Colors.red;
            statusIcon = Icons.cancel;
            statusText = 'Từ chối';
            break;
          default:
            statusColor = Colors.grey;
            statusIcon = Icons.help_outline;
            statusText = 'Không rõ';
        }

        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              // Restaurant image
              child: Image.network(
                restaurant.imageUrl ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.restaurant, size: 40, color: Colors.grey),
              ),
            ),

            // Restaurant name
            title: Text(
              restaurant.name ?? 'Không tên',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant description
                Text(
                  restaurant.description ?? 'Không có mô tả',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    // Icon
                    Icon(statusIcon, color: statusColor, size: 16),

                    const SizedBox(width: 4),

                    // Status
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              if (restaurantStatus.toUpperCase() == 'APPROVED') {
                // Navigate to restaurant detail
                context.push(
                  '/merchant/restaurant/${restaurant.id}/detail',
                  extra: widget.token,
                );
              } else {
                _showStatusSnackBar(context, restaurantStatus);
              }
            },
          ),
        );
      },
    );
  }
}
