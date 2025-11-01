import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant_menu.dart';
import 'package:pickme_fe_app/core/common_services/utils_method.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant.dart';
import 'package:go_router/go_router.dart';

class RestaurantMenuCard extends StatelessWidget {
  final RestaurantMenu m;
  final bool isHorizontal;
  final String token;
  final Restaurant restaurant;
  final VoidCallback? onTap;

  const RestaurantMenuCard({
    super.key,
    required this.m,
    required this.isHorizontal,
    required this.token,
    required this.restaurant,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final priceText = UtilsMethod.formatMoney(m.price);
    final isFavorite = ValueNotifier<bool>(false);

    // Method navigate to detail
    void navigateToDetail() async {
      final result = await context.pushNamed<bool>(
        'restaurant-menu-detail',
        pathParameters: {
          'id': restaurant.id.toString(),
          'menuId': m.id.toString(),
        },
        extra: {'token': token},
      );

      if (result == true && context.mounted) {
        debugPrint('Đã thêm món, cập nhật giỏ hàng...');
        onTap?.call();
      }
    }

    return ValueListenableBuilder<bool>(
      valueListenable: isFavorite,
      builder: (context, fav, _) {
        // Main card container
        return GestureDetector(
          onTap: navigateToDetail, // Entire card is tappable
          child: Container(
            width: isHorizontal ? 140 : double.infinity,
            margin: EdgeInsets.only(bottom: isHorizontal ? 0 : 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // food image
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      child: Image.network(
                        m.imageUrl.isNotEmpty
                            ? m.imageUrl
                            : 'https://picsum.photos/seed/food/200/200',
                        height: isHorizontal ? 120 : 90,
                        width: isHorizontal ? 140 : 90,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.fastfood, color: Colors.grey),
                        ),
                      ),
                    ),

                    // food details
                    if (!isHorizontal)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name
                              Text(
                                m.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 4),

                              // Price
                              Text(
                                priceText,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),

                //  Favorite icon
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      isFavorite.value = !isFavorite.value;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        fav ? Icons.favorite : Icons.favorite_border,
                        color: fav ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                // Add to cart button
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: navigateToDetail,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
