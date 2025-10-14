import 'package:flutter/material.dart';

class RestaurantOrder extends StatefulWidget {
  final String restaurantId;
  final String token;

  const RestaurantOrder({
    super.key,
    required this.restaurantId,
    required this.token,
  });

  @override
  State<RestaurantOrder> createState() => _RestaurantOrderState();
}

class _RestaurantOrderState extends State<RestaurantOrder> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder(child: Text("order"));
  }
}
