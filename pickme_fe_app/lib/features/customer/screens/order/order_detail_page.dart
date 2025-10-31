import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/common_services/utils_method.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/customer/models/order/order.dart';
import 'package:pickme_fe_app/features/customer/services/order/order_service.dart';

class OrderDetailPage extends StatefulWidget {
  final String token;
  final int orderId;

  const OrderDetailPage({
    super.key,
    required this.token,
    required this.orderId,
  });

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late Future<Order?> _order;

  @override
  void initState() {
    super.initState();
    _order = OrderService().getOrderById(widget.token, widget.orderId);
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

          // Render UI
          return ListView(
            padding: const EdgeInsets.all(8),
            children: [
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
            ],
          );
        },
      ),
    );
  }
}
