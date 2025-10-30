import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/common_services/utils_method.dart';
import 'package:pickme_fe_app/features/customer/models/cart/cart.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant.dart';

class MenuListCard extends StatelessWidget {
  final Restaurant restaurant;
  final List<CartItem> cartItems;
  final double subtotal;
  final double total;

  const MenuListCard({
    super.key,
    required this.restaurant,
    required this.cartItems,
    required this.subtotal,
    required this.total,
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
              // Icon address
              const Icon(Icons.location_on, size: 14, color: Colors.grey),

              const SizedBox(width: 4),

              // Address
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

          // List of food
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
                  _MenuItemTile(item: item),
                  const Divider(height: 20, color: Colors.black12),
                ],
              ),
            ),

          // Price
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
  const _MenuItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
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
              Text(
                item.menuItemName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (item.specialInstructions?.isNotEmpty ?? false)
                Text(
                  "Ghi chú: ${item.specialInstructions}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
            ],
          ),
        ),

        Text(
          UtilsMethod.formatMoney(item.unitPrice * item.quantity),
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
