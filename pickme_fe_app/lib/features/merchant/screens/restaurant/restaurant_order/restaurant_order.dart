import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/merchant/model/order.dart';
import 'package:pickme_fe_app/features/merchant/services/order/order_service.dart';

class RestaurantOrder extends StatefulWidget {
  final int restaurantId;
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
  final OrderService _orderService = OrderService();
  late Future<List<Order>> _ordersRestaurant;

  @override
  void initState() {
    super.initState();
    // Get active order
    _ordersRestaurant = _orderService.getAllOrdersOfRestaurant(
      widget.token,
      widget.restaurantId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      // Appbar
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "Đơn hàng",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
    );
  }
}
