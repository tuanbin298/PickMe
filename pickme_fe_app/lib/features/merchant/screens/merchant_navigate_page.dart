import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/features/merchant/model/restaurant.dart';
import 'package:pickme_fe_app/features/merchant/services/restaurant/restaurant_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MerchantNavigatePage extends StatefulWidget {
  const MerchantNavigatePage({super.key});

  @override
  State<MerchantNavigatePage> createState() => _MerchantNavigatePageState();
}

class _MerchantNavigatePageState extends State<MerchantNavigatePage> {
  // Create instance object of RestaurantServices
  final RestaurantServices _restaurantServices = RestaurantServices();

  // Init variable
  Future<List<Restaurant>>? _futureRestaurants;

  // Store data from _loadRestaurant into variable
  @override
  void initState() {
    super.initState();
    _futureRestaurants = _loadRestaurants();
  }

  // Method get restaurant data from services
  Future<List<Restaurant>> _loadRestaurants() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) return [];

    final restaurants = await _restaurantServices.getRestaurantsByOwner(token);
    return restaurants;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // FutureBuilder: listen to state, render ui base on state
      body: FutureBuilder<List<Restaurant>>(
        future: _futureRestaurants,
        builder: (context, snapshot) {
          // snapshot: contain current state of future
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Có lỗi xảy ra: ${snapshot.error}"));
          }

          final restaurants = snapshot.data ?? [];

          // Have restaurants
          if (restaurants.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go("/merchant-homepage");
            });
          }
          // Dont have restaurants
          else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go("/merchant-intro");
            });
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
