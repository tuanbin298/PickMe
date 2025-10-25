import 'package:flutter/material.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant_menu.dart';
import 'restaurant_menu_card.dart';

class RestaurantMenuList extends StatelessWidget {
  final Map<String, List<RestaurantMenu>> grouped;
  final Future<void> Function() onRefresh;
  final void Function(RestaurantMenu menu)? onTap;

  const RestaurantMenuList({
    super.key,
    required this.grouped,
    required this.onRefresh,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: grouped.entries.map((entry) {
          final category = entry.key;
          final items = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Title
              Text(
                category,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Menu Items
              Column(
                children: items
                    .map(
                      (m) => RestaurantMenuCard(
                        m: m,
                        isHorizontal: false,
                        onTap: () => onTap?.call(m),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
            ],
          );
        }).toList(),
      ),
    );
  }
}
