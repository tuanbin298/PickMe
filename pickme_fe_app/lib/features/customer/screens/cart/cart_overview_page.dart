import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/core/common_widgets/notification_service.dart';
import 'package:pickme_fe_app/features/customer/services/cart/cart_service.dart';

class CartOverviewPage extends StatefulWidget {
  final String token;

  const CartOverviewPage({super.key, required this.token});

  @override
  State<CartOverviewPage> createState() => _CartOverviewPageState();
}

class _CartOverviewPageState extends State<CartOverviewPage> {
  final CartService _cartService = CartService();
  bool isLoading = true;
  bool isDeleting = false; // ✅ Trạng thái loading khi xoá

  List<Map<String, dynamic>> carts = [];

  /// Cache số lượng món của từng nhà hàng (restaurantId -> count)
  Map<int, int> itemCounts = {};

  /// Quản lý chế độ “Quản lý”
  bool isManaging = false;

  /// Giữ danh sách cartId đã chọn
  Set<int> selectedCarts = {};

  @override
  void initState() {
    super.initState();
    _fetchCarts();
  }

  /// Lấy danh sách giỏ hàng + số lượng món ăn (song song)
  Future<void> _fetchCarts() async {
    try {
      final result = await _cartService.getAllCarts(token: widget.token);

      // Gọi song song tất cả getCartItemCount
      final futures = <Future<void>>[];
      final counts = <int, int>{};

      for (final cart in result) {
        final restaurant = cart['restaurant'];
        final restaurantId = restaurant?['id'];
        if (restaurantId != null) {
          futures.add(
            _cartService
                .getCartItemCount(
                  token: widget.token,
                  restaurantId: restaurantId,
                )
                .then((count) {
                  counts[restaurantId] = count;
                }),
          );
        }
      }

      await Future.wait(futures);

      if (!mounted) return;
      setState(() {
        carts = result;
        itemCounts = counts;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      NotificationService.showError(context, "Không thể tải giỏ hàng!");
      setState(() => isLoading = false);
    }
  }

  /// Xoá tất cả các giỏ hàng đã chọn
  Future<void> _deleteSelectedCarts() async {
    if (selectedCarts.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xác nhận xoá"),
        content: Text(
          "Bạn có chắc muốn xoá ${selectedCarts.length} giỏ hàng không?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Huỷ"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Xoá"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => isDeleting = true); // ✅ Bắt đầu hiệu ứng load

    try {
      for (final id in selectedCarts) {
        await _cartService.clearCart(widget.token, id);
      }

      if (!mounted) return;
      NotificationService.showSuccess(
        context,
        "Đã xoá ${selectedCarts.length} giỏ hàng",
      );

      setState(() {
        carts.removeWhere((c) => selectedCarts.contains(c['id']));
        selectedCarts.clear();
      });
    } catch (e) {
      if (!mounted) return;
      NotificationService.showError(context, "Xoá thất bại!");
    } finally {
      if (mounted) setState(() => isDeleting = false); // ✅ Ẩn hiệu ứng load
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAllSelected =
        selectedCarts.length == carts.length && carts.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Giỏ hàng của tôi",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            if (isManaging) {
              setState(() {
                isManaging = false;
                selectedCarts.clear();
              });
            } else {
              context.pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                isManaging = !isManaging;
                selectedCarts.clear();
              });
            },
            child: Text(
              isManaging ? "Huỷ" : "Quản lý",
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (carts.isEmpty)
            const Center(child: Text("Chưa có giỏ hàng nào"))
          else
            Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: carts.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final cart = carts[index];
                      final restaurant = cart['restaurant'];
                      final restaurantId = restaurant?['id'];
                      final restaurantName =
                          restaurant?['name'] ?? 'Không xác định';
                      final restaurantImage =
                          restaurant?['imageUrl'] ??
                          "https://via.placeholder.com/100x100.png?text=Restaurant";
                      final distance =
                          restaurant?['distance']?.toStringAsFixed(1) ?? "–";
                      final timeEstimate =
                          restaurant?['deliveryTime'] ?? "30 phút trở lên";

                      final count = itemCounts[restaurantId] ?? 0;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isManaging)
                              Checkbox(
                                value: selectedCarts.contains(cart['id']),
                                onChanged: (checked) {
                                  setState(() {
                                    if (checked == true) {
                                      selectedCarts.add(cart['id']);
                                    } else {
                                      selectedCarts.remove(cart['id']);
                                    }
                                  });
                                },
                              ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                restaurantImage,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          restaurantName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          "$count món • $timeEstimate • $distance km",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                        onTap: isManaging
                            ? () {
                                setState(() {
                                  if (selectedCarts.contains(cart['id'])) {
                                    selectedCarts.remove(cart['id']);
                                  } else {
                                    selectedCarts.add(cart['id']);
                                  }
                                });
                              }
                            : () {
                                context.push(
                                  "/cart-confirm",
                                  extra: {
                                    "token": widget.token,
                                    "restaurant": restaurant,
                                    "cartId": cart['id'],
                                  },
                                );
                              },
                      );
                    },
                  ),
                ),
                if (isManaging)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey)),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isAllSelected,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                selectedCarts = carts
                                    .map((e) => e['id'] as int)
                                    .toSet();
                              } else {
                                selectedCarts.clear();
                              }
                            });
                          },
                        ),
                        const Text("Chọn tất cả"),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: selectedCarts.isEmpty
                              ? null
                              : _deleteSelectedCarts,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text("Xoá (${selectedCarts.length})"),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

          // ✅ Hiệu ứng overlay khi xoá
          AnimatedOpacity(
            opacity: isDeleting ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: IgnorePointer(
              ignoring: !isDeleting,
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
