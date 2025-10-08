import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/merchant/model/restaurant.dart';
import 'package:pickme_fe_app/features/merchant/services/restaurant/restaurant_services.dart';

class RestaurantListPage extends StatefulWidget {
  final String token;

  const RestaurantListPage({super.key, required this.token});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  final RestaurantServices _restaurantServices = RestaurantServices();

  late Future<List<Restaurant>> _futureRestaurants;

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  // Method call service to get restaurant
  void _loadRestaurants() {
    _futureRestaurants = _restaurantServices.getRestaurantsByOwner(
      widget.token,
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
              final result = await context.push("/merchant-create-resaurant");

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
          // Waiting to data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
          }

          final restaurants = snapshot.data;
          if (restaurants == null) {
            return const Center(child: Text("Không có thông tin cửa hàng"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  //  Restaurant Image
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      restaurant.imageUrl ?? '',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      // If image error show icon
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.restaurant,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  // Restaurant name
                  title: Text(
                    restaurant.name ?? 'Không tên',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // Restauant descripttion
                  subtitle: Text(
                    restaurant.description ?? 'Không có mô tả',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              );
            },
          );
        },
      ),
    );
  }
}
