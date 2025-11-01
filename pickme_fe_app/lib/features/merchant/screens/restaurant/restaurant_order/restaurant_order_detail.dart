import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/common_services/utils_method.dart';
import 'package:pickme_fe_app/core/common_widgets/notification_service.dart';
import 'package:pickme_fe_app/core/common_widgets/status.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/merchant/model/order.dart';
import 'package:pickme_fe_app/features/merchant/services/order/order_service.dart';
import 'package:pickme_fe_app/features/merchant/widgets/order/update_order_status.dart';

class RestaurantOrderDetail extends StatefulWidget {
  final String token;
  final int orderId;

  const RestaurantOrderDetail({
    super.key,
    required this.token,
    required this.orderId,
  });

  @override
  State<RestaurantOrderDetail> createState() => _RestaurantOrderDetailState();
}

class _RestaurantOrderDetailState extends State<RestaurantOrderDetail> {
  late Future<Order?> _order;

  @override
  void initState() {
    super.initState();
    _order = OrderService().getOrderById(widget.token, widget.orderId);
  }

  // Method update order status
  Future<void> onUpdate(String status) async {
    try {
      await OrderService().updateOrderStatus(
        widget.token,
        widget.orderId,
        status,
      );

      // Reload UI
      setState(() {
        _order = OrderService().getOrderById(widget.token, widget.orderId);
      });

      if (mounted) {
        NotificationService.showSuccess(
          context,
          "Cập nhật trạng thái thành công",
        );
      }
    } catch (e) {
      if (mounted) {
        NotificationService.showError(context, "Cập nhật trạng thái thất bại");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // Appbar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: const Text(
          "Chi tiết đơn hàng",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: FutureBuilder<Order?>(
        future: _order,

        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }

          final order = snapshot.data;
          if (order == null) {
            return const Center(child: Text("Không tìm thấy đơn hàng"));
          }

          // Formatter status
          final (orderText, orderIcon, orderColor) = mapOrderStatus(
            order.status ?? "",
          );
          final (paymentText, paymentIcon, paymentColor) = mapPaymentStatus(
            order.paymentStatus ?? "",
          );

          // Render UI
          return ListView(
            padding: const EdgeInsets.all(8),
            children: [
              // Status cards
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Order status
                          Icon(orderIcon, color: orderColor, size: 28),

                          const SizedBox(height: 4),

                          // Payment status
                          Text(
                            orderText,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: orderColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(paymentIcon, color: paymentColor, size: 28),
                          const SizedBox(height: 4),
                          Text(
                            paymentText,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: paymentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Order items
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "Món đã đặt",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const Divider(height: 1),

                    // Render order item
                    ...order.orderItems!.map((item) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 8,
                        ),

                        // order item image
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.menuItemImageUrl ?? "",
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Order item name
                        title: Text(
                          item.menuItemName ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Order item description
                            Text(item.menuItemDescription ?? ""),

                            const SizedBox(height: 4),

                            // Order item category
                            Text(
                              "Danh mục: ${item.menuItemCategory}",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Order item quanity
                            Text(
                              "x${item.quantity}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),

                            // Order item price
                            Text(
                              UtilsMethod.formatMoney(item.unitPrice ?? 0),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Update order section
              UpdateOrderStatus(initialStatus: orderText, onUpdate: onUpdate),
            ],
          );
        },
      ),
    );
  }
}
