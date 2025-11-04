import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/core/common_services/utils_method.dart';
import 'package:pickme_fe_app/core/common_widgets/status.dart';
import 'package:pickme_fe_app/features/customer/models/order/order.dart';
import 'package:pickme_fe_app/features/customer/models/review/review.dart';
import 'package:pickme_fe_app/features/customer/services/order/order_service.dart';
import 'package:pickme_fe_app/features/customer/services/review/review_service.dart';

class OrderHistoryTab extends StatefulWidget {
  final String token;

  const OrderHistoryTab({super.key, required this.token});

  @override
  State<OrderHistoryTab> createState() => _OrderHistoryTabState();
}

class _OrderHistoryTabState extends State<OrderHistoryTab> {
  final OrderService _orderService = OrderService();
  final ReviewService _reviewService = ReviewService();
  // Load the user's order history
  late Future<List<Order>> _historyOrder;
  // Fetch all reviews made by the user
  Future<List<Review>>? _reviewsFuture;
  List<Review> _reviews = [];

  @override
  void initState() {
    super.initState();
    _historyOrder = _orderService.getHistoryOrder(widget.token);
    _reviewsFuture = _fetchAllReviews();
  }

  /// Fetches all reviews submitted by the current user.
  Future<List<Review>> _fetchAllReviews() async {
    try {
      debugPrint("Đang tải tất cả review của user hiện tại...");
      final reviews = await _reviewService.getMyReviews(token: widget.token);
      debugPrint("Tải thành công ${reviews.length} review");
      for (var r in reviews) {
        debugPrint(
          "Review: id=${r.id}, type=${r.reviewType}, comment=${r.comment}",
        );
      }
      return reviews;
    } catch (e) {
      debugPrint(" Lỗi tải danh sách review: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: _historyOrder,
      builder: (context, snapshot) {
        // Show loading indicator while fetching order history
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error if fetching order history fails
        if (snapshot.hasError) {
          return Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
        }

        final ordersHistory = snapshot.data ?? [];

        // Show empty state if no orders found
        if (ordersHistory.isEmpty) {
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

        return FutureBuilder<List<Review>>(
          future: _reviewsFuture ?? Future.value([]),
          builder: (context, reviewSnap) {
            // Show loading indicator while fetching reviews
            if (reviewSnap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            _reviews = reviewSnap.data ?? [];

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ordersHistory.length,
              itemBuilder: (context, index) {
                final order = ordersHistory[index];
                final restaurant = order.restaurant;

                // Map order and payment status to display text, icon and color
                final (orderText, orderIcon, orderColor) = mapOrderStatus(
                  order.status ?? "",
                );

                final (paymentText, paymentIcon, paymentColor) =
                    mapPaymentStatus(order.paymentStatus ?? "");

                // Determine if feedback button should be shown (completed/delivered orders)
                final bool showFeedbackButton =
                    (order.status?.toLowerCase() == "completed" ||
                    order.status?.toLowerCase() == "delivered");

                final existingReview = _reviews.firstWhere(
                  (r) => r.restaurantId == order.restaurant?.id,
                  orElse: () =>
                      Review(orderId: -1, overallRating: 0, comment: ''),
                );

                final bool hasReviewed = existingReview.orderId != -1;

                debugPrint(
                  "🔍 Kiểm tra order ${order.id} - quán ${restaurant?.name}: hasReviewed=$hasReviewed",
                );

                return GestureDetector(
                  // Navigate to order details page
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
                          // Order information row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Restaurant image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  restaurant?.imageUrl ?? "",
                                  width: 160,
                                  height: 170,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 160,
                                    height: 170,
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Order ID
                                    Text(
                                      "Mã đơn: ${order.id}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    // Restaurant name
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
                                    // Total amount
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

                          // Feedback button for completed/delivered orders
                          if (showFeedbackButton) ...[
                            const SizedBox(height: 14),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.orange.shade100,
                                ),
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
                                  Text(
                                    hasReviewed
                                        ? "Bạn đã đánh giá nhà hàng này"
                                        : "Hài lòng với đơn hàng này?",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (!hasReviewed) {
                                          final result = await context.push(
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

                                          // Reload feedback page when user finish feedback
                                          if (result == true) {
                                            setState(() {
                                              _reviewsFuture =
                                                  _fetchAllReviews();
                                            });
                                          }
                                        } else {
                                          context.pushNamed(
                                            'restaurant-menu',
                                            pathParameters: {
                                              'id':
                                                  restaurant?.id.toString() ??
                                                  '',
                                            },
                                            extra: {
                                              'restaurant': restaurant,
                                              'token': widget.token,
                                              'initialTabIndex': 1,
                                            },
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: hasReviewed
                                            ? Colors.grey
                                            : Colors.orange,
                                        foregroundColor: Colors.white,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 22,
                                          vertical: 10,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            hasReviewed
                                                ? Icons.visibility
                                                : Icons.rate_review,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            hasReviewed
                                                ? "Xem lại đánh giá"
                                                : "Đánh giá ngay",
                                            style: const TextStyle(
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
      },
    );
  }
}
