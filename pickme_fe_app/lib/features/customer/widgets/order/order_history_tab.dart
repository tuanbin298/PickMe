import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/core/common_services/utils_method.dart';
import 'package:pickme_fe_app/core/common_widgets/status.dart';
import 'package:pickme_fe_app/features/customer/models/order/order.dart';
import 'package:pickme_fe_app/features/customer/services/order/order_service.dart';

class OrderHistoryTab extends StatefulWidget {
  final String token;

  const OrderHistoryTab({super.key, required this.token});

  @override
  State<OrderHistoryTab> createState() => _OrderHistoryTabState();
}

class _OrderHistoryTabState extends State<OrderHistoryTab> {
  final OrderService _orderService = OrderService();
  late Future<List<Order>> _historyOrder;

  @override
  void initState() {
    super.initState();
    // Get history order
    _historyOrder = _orderService.getHistoryOrder(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: _historyOrder,
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error
        if (snapshot.hasError) {
          return Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
        }

        final ordersHistory = snapshot.data;

        // Dont have order
        if (ordersHistory == null || ordersHistory.isEmpty) {
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
          itemCount: ordersHistory.length,
          itemBuilder: (context, index) {
            final order = ordersHistory[index];
            final restaurant = order.restaurant;

            // Formatter status
            final (orderText, orderIcon, orderColor) = mapOrderStatus(
              order.status ?? "",
            );
            final (paymentText, paymentIcon, paymentColor) = mapPaymentStatus(
              order.paymentStatus ?? "",
            );
            final bool showFeedbackButton =
                (order.status?.toLowerCase() == "completed" ||
                order.status?.toLowerCase() == "delivered");

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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

                                // Order item name
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
                                    Icon(
                                      orderIcon,
                                      size: 18,
                                      color: orderColor,
                                    ),

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

                      // feedback button
                      if (showFeedbackButton) ...[
                        const SizedBox(height: 14),

                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.orange.shade100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              const Text(
                                "Hài lòng với đơn hàng này?",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),

                              const SizedBox(height: 10),

                              // Btn feedback
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.push(
                                      "/orders/${order.id}/review",
                                      extra: {
                                        "orderId": order.id,
                                        "restaurantId": restaurant?.id,
                                        "restaurantName":
                                            restaurant?.name ??
                                            "Không rõ tên quán",
                                        "restaurantImage":
                                            restaurant?.imageUrl ?? '',
                                        "token": widget.token,
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 22,
                                      vertical: 10,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.rate_review, size: 18),

                                      SizedBox(width: 8),

                                      Text(
                                        "Đánh giá ngay",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
