import 'package:flutter/material.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant_menu.dart';
import 'restaurant_header.dart';
import 'restaurant_info_card.dart';
import 'restaurant_review_tab.dart';
import 'restaurant_menu_list.dart';

class RestaurantMenuTabView extends StatelessWidget {
  final Restaurant restaurant;
  final List<RestaurantMenu> menus;
  final TabController tabController;
  final Future<void> Function() onRefresh;
  final void Function(RestaurantMenu menu) onTap;
  final bool unavailable;
  final String token;

  const RestaurantMenuTabView({
    super.key,
    required this.restaurant,
    required this.menus,
    required this.tabController,
    required this.onRefresh,
    required this.onTap,
    required this.token,
    this.unavailable = false,
  });

  @override
  Widget build(BuildContext context) {
    // Group menus by category
    final Map<String, List<RestaurantMenu>> grouped = {};

    for (var m in menus) {
      final cat = (m.category.isNotEmpty) ? m.category : 'Khác';
      grouped.putIfAbsent(cat, () => []);
      grouped[cat]!.add(m);
    }
    // Main layout
    // NestedScrollView: show appbar when scroll
    return NestedScrollView(
      headerSliverBuilder: (context, _) => [
        // Restaurant image
        SliverAppBar(
          pinned: true,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            background: RestaurantHeader(imageUrl: restaurant.imageUrl),
          ),
        ),
      ],
      body: Column(
        // Main content
        children: [
          Padding(
            padding: const EdgeInsets.all(12),

            // Restaurant info card
            child: RestaurantInfoCard(restaurant: restaurant),
          ),

          // Tab Bar
          TabBar(
            controller: tabController,
            labelColor: Colors.black,
            tabs: const [
              Tab(text: 'Thực đơn'),

              Tab(text: 'Đánh giá'),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                // Tab Menu
                IgnorePointer(
                  ignoring: unavailable,
                  child: Opacity(
                    opacity: unavailable ? 0.5 : 1.0,
                    child: RefreshIndicator(
                      onRefresh: onRefresh,

                      child: RestaurantMenuList(
                        grouped: grouped,
                        onRefresh: onRefresh,
                        onTap: unavailable ? null : onTap,
                        token: token,
                        restaurant: restaurant,
                      ),
                    ),
                  ),
                ),

                // Tab Reviews
                const RestaurantReviewTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
