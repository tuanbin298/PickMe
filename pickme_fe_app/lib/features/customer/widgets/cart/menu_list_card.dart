import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/common_services/utils_method.dart';
import 'package:pickme_fe_app/features/customer/models/cart/cart.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant.dart';

class MenuListCard extends StatelessWidget {
  final Restaurant restaurant;
  final List<CartItem> cartItems;
  final double subtotal;
  final double total;

  /// Callback khi thay đổi số lượng
  final Function(CartItem item, int newQuantity)? onUpdateQuantity;

  /// Callback khi xóa item
  final Function(CartItem item)? onRemove;

  const MenuListCard({
    super.key,
    required this.restaurant,
    required this.cartItems,
    required this.subtotal,
    required this.total,
    this.onUpdateQuantity,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurant.name,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  restaurant.address,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (cartItems.isEmpty)
            const Center(
              child: Text(
                "Giỏ hàng trống",
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ...cartItems.map(
              (item) => Column(
                children: [
                  Dismissible(
                    key: ValueKey(item.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.shade400,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Xóa món này?"),
                          content: const Text(
                            "Bạn có chắc chắn muốn xóa món này khỏi giỏ hàng không?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text("Hủy"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text(
                                "Xóa",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) {
                      onRemove?.call(item);
                    },
                    child: _MenuItemTile(
                      item: item,
                      onUpdateQuantity: onUpdateQuantity,
                    ),
                  ),
                  const Divider(height: 20, color: Colors.black12),
                ],
              ),
            ),

          const SizedBox(height: 8),
          _buildAmountRow("Tổng tạm tính", subtotal),
          const SizedBox(height: 8),
          _buildAmountRow("Voucher", 0),
          const Divider(height: 24, color: Colors.black12),
          _buildAmountRow(
            "Tổng cộng",
            total,
            isTotal: true,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
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
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Widget _buildAmountRow(
    String label,
    double value, {
    bool isTotal = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          UtilsMethod.formatMoney(value),
          style: TextStyle(
            color: color ?? Colors.black,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _MenuItemTile extends StatelessWidget {
  final CartItem item;
  final Function(CartItem item, int newQuantity)? onUpdateQuantity;

  const _MenuItemTile({required this.item, this.onUpdateQuantity});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            item.menuItemImageUrl,
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
              // 🍔 Tên món
              Text(
                item.menuItemName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),

              // 🧀 Addons
              if (item.addOns != null && item.addOns!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    "+ ${item.addOns!.map((a) => a.name).join(', ')}",
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),

              // 📝 Ghi chú
              if (item.specialInstructions?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    "Ghi chú: ${item.specialInstructions}",
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),

              const SizedBox(height: 6),

              // 🔢 Số lượng & giá
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nút + -
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.grey,
                        ),
                        onPressed: item.quantity > 1
                            ? () => onUpdateQuantity?.call(
                                item,
                                item.quantity - 1,
                              )
                            : null,
                        constraints: const BoxConstraints(),
                      ),
                      Text(
                        "${item.quantity}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.orange,
                        ),
                        onPressed: () =>
                            onUpdateQuantity?.call(item, item.quantity + 1),
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),

                  // Tổng tiền món
                  Text(
                    UtilsMethod.formatMoney(item.unitPrice * item.quantity),
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
