import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/features/merchant/model/restaurant.dart';
import 'package:pickme_fe_app/features/merchant/services/restaurant_services.dart';
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
  Future<Restaurant?>? _futureRestaurant;

  // Store data from _loadRestaurant into variable
  @override
  void initState() {
    super.initState();
    _futureRestaurant = _loadRestaurant();
  }

  // Method get restaurant data from services
  Future<Restaurant?> _loadRestaurant() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) return null;

    return await _restaurantServices.getRestaurantsByOwner(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // FutureBuilder: listen to state, render ui base on state
      body: FutureBuilder<Restaurant?>(
        future: _futureRestaurant,
        builder: (context, snapshot) {
          // snapshot: contain current state of future
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Có lỗi xảy ra: ${snapshot.error}"));
          }

          // Navigate base on data of restaurant
          if (snapshot.data != null) {
            // WidgetsBinding.instance.addPostFrameCallback: navigate after next UI is rendered
            // This prevents calling context.go() during the build phase
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go("/merchant-intro");
            });

            return const SizedBox.shrink(); //If dont return not thing it will return SizedBox.shrink()
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go("/merchant-intro");
            });

            return const SizedBox.shrink(); //If dont return not thing it will return SizedBox.shrink()
          }
        },
      ),
    );
  }
}
