import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant_menu.dart';
import 'restaurant_menu_list.dart';

class RestaurantMenuTabView extends StatelessWidget {
  final Restaurant restaurant;
  final List<RestaurantMenu> menus;
  final TabController tabController;
  final Future<void> Function() onRefresh;

  const RestaurantMenuTabView({
    super.key,
    required this.restaurant,
    required this.menus,
    required this.tabController,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, List<RestaurantMenu>> grouped = {};
    for (var m in menus) {
      final cat = (m.category.isNotEmpty) ? m.category : 'Khác';
      grouped.putIfAbsent(cat, () => []);
      grouped[cat]!.add(m);
    }

    return CustomScrollView(
      slivers: [
        _buildHeader(context, restaurant),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRestaurantInfo(restaurant),
                const SizedBox(height: 10),
                TabBar(
                  controller: tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.primary,
                  tabs: const [
                    Tab(text: "Menu"),
                    Tab(text: "Đánh giá"),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          child: TabBarView(
            controller: tabController,
            children: [
              RestaurantMenuList(grouped: grouped, onRefresh: onRefresh),
              const Center(child: Text("Chưa có đánh giá")),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, Restaurant restaurant) {
    final imageUrl = restaurant.imageUrl.isNotEmpty
        ? restaurant.imageUrl
        : 'https://picsum.photos/seed/restaurant/800/400';
    return SliverAppBar(
      pinned: false,
      expandedHeight: 180,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.restaurant, size: 48),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantInfo(Restaurant restaurant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                restaurant.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (restaurant.isApproved == true)
              const Icon(Icons.verified, color: Colors.green),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 18),
            const SizedBox(width: 4),
            Text(
              restaurant.rating.toStringAsFixed(1),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.schedule, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              '${restaurant.openingTime} - ${restaurant.closingTime}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 16,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                restaurant.address,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: const [
              Icon(Icons.local_offer, color: Colors.orange, size: 18),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Giảm 20.000đ cho đơn từ 30.000đ',
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
