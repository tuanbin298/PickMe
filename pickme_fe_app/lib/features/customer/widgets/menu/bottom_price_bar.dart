import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/common_services/utils_method.dart';

class BottomPriceBar extends StatelessWidget {
  final double totalPrice;
  final bool loadingAddToCart;
  final VoidCallback onAddToCart;

  const BottomPriceBar({
    super.key,
    required this.totalPrice,
    required this.loadingAddToCart,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Giá',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                UtilsMethod.formatMoney(totalPrice),
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 200,
            height: 48,
            child: ElevatedButton(
              onPressed: loadingAddToCart ? null : onAddToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: loadingAddToCart
                  ? const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    )
                  : const Text(
                      'Thêm vào giỏ hàng',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
