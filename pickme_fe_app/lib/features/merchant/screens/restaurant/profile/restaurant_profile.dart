import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';

class RestaurantProfile extends StatefulWidget {
  final String restaurantId;
  final String token;

  const RestaurantProfile({
    super.key,
    required this.restaurantId,
    required this.token,
  });

  @override
  State<RestaurantProfile> createState() => _RestaurantProfileState();
}

class _RestaurantProfileState extends State<RestaurantProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar
      appBar: AppBar(
        title: const Text(
          'Thông tin của quán ăn',
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
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
