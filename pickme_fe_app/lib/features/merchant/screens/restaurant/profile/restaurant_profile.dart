import 'package:flutter/material.dart';

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
    return const Placeholder(child: Text("Profile"));
  }
}
