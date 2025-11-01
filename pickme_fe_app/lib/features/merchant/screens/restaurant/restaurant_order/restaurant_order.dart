import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/core/common_services/utils_method.dart';
import 'package:pickme_fe_app/core/common_widgets/status.dart';
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
  late Future<List<Order>> _ordersRestaurantFuture;

  @override
  void initState() {
    super.initState();
    // Get active order
    _ordersRestaurantFuture = _orderService.getAllOrdersOfRestaurant(
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

      body: FutureBuilder<List<Order>>(
        future: _ordersRestaurantFuture,
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
          }

          final ordersRestaurant = snapshot.data;

          // Dont have order
          if (ordersRestaurant == null || ordersRestaurant.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hourglass_empty, size: 60, color: Colors.orange),

                  SizedBox(height: 16),

                  Text(
                    "Bạn chưa có đơn hàng nào",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Have order
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ordersRestaurant.length,
            itemBuilder: (context, index) {
              final order = ordersRestaurant[index];
              final restaurant = order.restaurant;

              // Formatter status
              final (orderText, orderIcon, orderColor) = mapOrderStatus(
                order.status ?? "",
              );
              final (paymentText, paymentIcon, paymentColor) = mapPaymentStatus(
                order.paymentStatus ?? "",
              );

              return GestureDetector(
                onTap: () {
                  context.push(
                    "/restaurant/${widget.restaurantId}/orders/${order.id}",
                    extra: {"orderId": order.id, "token": widget.token},
                  );
                },
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Orderitem image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            restaurant?.imageUrl ?? "",
                            width: 160,
                            height: 170,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Order id
                              Text(
                                "Mã đơn: ${order.id}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // Orderitem name
                              Text(
                                restaurant?.name ?? "Không rõ tên quán",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Order status
                              Row(
                                children: [
                                  Icon(orderIcon, size: 18, color: orderColor),

                                  const SizedBox(width: 6),

                                  Text(
                                    orderText,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: orderColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 4),

                              // Payment status
                              Row(
                                children: [
                                  Icon(
                                    paymentIcon,
                                    size: 18,
                                    color: paymentColor,
                                  ),

                                  const SizedBox(width: 6),

                                  Text(
                                    paymentText,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: paymentColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // Total price
                              Row(
                                children: [
                                  const Icon(
                                    Icons.attach_money,
                                    size: 18,
                                    color: Colors.black54,
                                  ),

                                  const SizedBox(width: 6),

                                  Text(
                                    UtilsMethod.formatMoney(
                                      order.totalAmount ?? 0,
                                    ),

                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
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
        },
      ),
    );
  }
}
