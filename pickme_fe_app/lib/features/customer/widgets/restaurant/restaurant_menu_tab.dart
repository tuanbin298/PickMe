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
  final void Function(RestaurantMenu menu)? onTap;

  const RestaurantMenuTabView({
    super.key,
    required this.restaurant,
    required this.menus,
    required this.tabController,
    required this.onRefresh,
    this.onTap,
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
              /// Tab Menu
              RestaurantMenuList(
                grouped: grouped,
                onRefresh: onRefresh,
                onTap: onTap,
              ),

              /// Tab Đánh giá
              _buildReviewTab(),
            ],
          ),
        ),
      ],
    );
  }

  // Header ảnh nhà hàng
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

  // Restaurant Info UI
  Widget _buildRestaurantInfo(Restaurant restaurant) {
    // Format lại giờ chỉ lấy giờ:phút
    String formatTime(String time) {
      try {
        final parsedTime = DateFormat("HH:mm:ss").parse(time);
        return DateFormat("HH:mm").format(parsedTime);
      } catch (_) {
        // Nếu không parse được (ví dụ API trả sẵn HH:mm) thì trả luôn
        return time;
      }
    }

    final opening = formatTime(restaurant.openingTime);
    final closing = formatTime(restaurant.closingTime);

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
              '$opening - $closing',
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
                  'Giảm 32.000đ cho đơn từ 200.000đ',
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Tab "Đánh giá" UI
  Widget _buildReviewTab() {
    final List<Map<String, dynamic>> reviews = [
      {
        'name': 'Nguyễn Văn A',
        'avatar': 'https://i.pravatar.cc/100?img=1',
        'time': 'Hôm nay, 18:40',
        'rating': 5,
        'content':
            'Đây là một trong những quán ăn yêu thích của mình, món ăn rất ngon và rẻ. Mọi người nên ghé ủng hộ quán nhé!',
        'likes': 68,
      },
      {
        'name': 'Nguyễn Văn A',
        'avatar': 'https://i.pravatar.cc/100?img=2',
        'time': 'Hôm nay, 09:12',
        'rating': 4,
        'content':
            'Thức ăn hơi mặn một chút, nhưng quán chuẩn bị món rất đúng giờ, chủ quán thân thiện.',
        'likes': 132,
      },
      {
        'name': 'Nguyễn Văn A',
        'avatar': 'https://i.pravatar.cc/100?img=3',
        'time': 'Hôm nay, 18:40',
        'rating': 5,
        'content':
            'Amazing food. Lots of choice. Will definitely plan to go again!',
        'likes': 99,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final r = reviews[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(r['avatar']),
                radius: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          r['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          r['time'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < r['rating'] ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(r['content'], style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          color: Colors.orange.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${r['likes']} lượt thích',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
