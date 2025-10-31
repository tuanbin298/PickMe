import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/core/common_services/utils_method.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/customer/models/order/order.dart';
import 'package:pickme_fe_app/features/customer/screens/qr_code/payment_qr_page.dart';
import 'package:pickme_fe_app/features/customer/services/order/order_service.dart';
import 'package:pickme_fe_app/features/customer/services/payment/payment_service.dart';
import 'package:pickme_fe_app/features/customer/widgets/cart/payment_section.dart';

class OrderConfirmPage extends StatefulWidget {
  final String token;
  final int id;

  const OrderConfirmPage({super.key, required this.token, required this.id});

  @override
  State<OrderConfirmPage> createState() => _OrderConfirmPageState();
}

class _OrderConfirmPageState extends State<OrderConfirmPage> {
  late Future<Order?> _order;
  bool payWithVisa = true;
  String paymentMethod = "SEPAY";

  final PaymentService _paymentService = PaymentService();

  @override
  void initState() {
    super.initState();
    _order = OrderService().getOrderById(widget.token, widget.id);
  }

  // Method to payment
  void _handleConfirmOrder() async {
    final payment = await _paymentService.createPayment(
      token: widget.token,
      orderId: widget.id,
      paymentMethod: paymentMethod,
    );

    if (payment != null) {
      if (payment.paymentMethod == "SEPAY") {
        context.go("/payment-qr", extra: {"qrCodeUrl": payment.qrCodeUrl});
        return;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Thanh toán thất bại!"),
          backgroundColor: Colors.red,
        ),
      );
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
          "Xác nhận đơn hàng",
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
            padding: const EdgeInsets.all(16),
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
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Text(
                        "Đơn hàng của bạn",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Loop in order: loop each obj in array
                      ...order.orderItems!.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              // Image food
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.menuItemImageUrl ?? "",
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Food name
                                    Text(
                                      item.menuItemName ?? "",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    // Food quantity
                                    Text(
                                      "Số lượng: ${item.quantity}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Food price
                              Text(
                                UtilsMethod.formatMoney(item.unitPrice ?? 0),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const Divider(height: 32, thickness: 1),

                      // Order total price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tổng cộng:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),

                          Text(
                            UtilsMethod.formatMoney(order.totalAmount ?? 0),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Order destination
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
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, color: AppColors.primary),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          order.deliveryAddress ?? "Không có địa chỉ giao hàng",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 0),
            ],
          );
        },
      ),

      // PaymentSection
      bottomNavigationBar: PaymentSection(
        payWithVisa: payWithVisa,
        onChanged: (value) {
          setState(() {
            payWithVisa = value;
            paymentMethod = value ? "SEPAY" : "CASH";
          });
        },
        onConfirm: _handleConfirmOrder,
      ),
    );
  }
}
