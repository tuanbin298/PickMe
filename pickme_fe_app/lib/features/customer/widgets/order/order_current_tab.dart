import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/core/common_services/utils_method.dart';
import 'package:pickme_fe_app/core/common_widgets/status.dart';
import 'package:pickme_fe_app/features/customer/models/order/order.dart';
import 'package:pickme_fe_app/features/customer/services/order/order_service.dart';

class OrderCurrentTab extends StatefulWidget {
  final String token;

  const OrderCurrentTab({super.key, required this.token});

  @override
  State<OrderCurrentTab> createState() => _OrderCurrentTabState();
}

class _OrderCurrentTabState extends State<OrderCurrentTab> {
  final OrderService _orderService = OrderService();
  late Future<List<Order>> _activeOrderFuture;

  @override
  void initState() {
    super.initState();
    // Get active order
    _activeOrderFuture = _orderService.getActiveOrder(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: _activeOrderFuture,
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error
        if (snapshot.hasError) {
          return Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
        }

        final orders = snapshot.data;

        // Dont have order
        if (orders == null || orders.isEmpty) {
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
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
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
                  "/orders/${order.id}",
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
    );
  }
}
