import 'package:flutter/material.dart';
import '../../models/restaurant/restaurant.dart';

class RestaurantMenuPage extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantMenuPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final popularDishes = [
      {
        'name': 'Thịt kho trứng',
        'price': 38000,
        'image': 'https://images.unsplash.com/photo-1606755962773-d324e0a13088',
      },
      {
        'name': 'Ba rọi xào mắm ruốc',
        'price': 38000,
        'image': 'https://images.unsplash.com/photo-1576402187878-974f70cb73d4',
      },
      {
        'name': 'Cá ba sa kho tiêu',
        'price': 38000,
        'image': 'https://images.unsplash.com/photo-1617196036507-04db8a6a2c28',
      },
    ];

    final todaySpecial = [
      {
        'name': 'Xíu mại trứng cút',
        'price': 38000,
        'image': 'https://images.unsplash.com/photo-1638438646987-9138bc5a11e4',
      },
      {
        'name': 'Cá ngừ kho thơm',
        'price': 38000,
        'image': 'https://images.unsplash.com/photo-1625941361030-fbb3b3c2b5f8',
      },
      {
        'name': 'Cá chốt kho sả',
        'price': 38000,
        'image': 'https://images.unsplash.com/photo-1606813902917-7b174d0be9ce',
      },
    ];

    final comboDishes = [
      {
        'name': 'Thịt kho trứng',
        'price': 38000,
        'image': 'https://images.unsplash.com/photo-1606755962773-d324e0a13088',
      },
      {
        'name': 'Ba rọi xào mắm ruốc',
        'price': 38000,
        'image': 'https://images.unsplash.com/photo-1576402187878-974f70cb73d4',
      },
      {
        'name': 'Cá bóng lao',
        'price': 38000,
        'image': 'https://images.unsplash.com/photo-1625941361030-fbb3b3c2b5f8',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ---------- ẢNH BÌA ----------
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                restaurant.imageUrl ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ---------- THÔNG TIN QUÁN ----------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          restaurant.address ?? 'Không có địa chỉ',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      const Text(
                        "4.6",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "5 phút • 1.2 km",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const Spacer(),
                      const Icon(Icons.circle, size: 10, color: Colors.green),
                      const SizedBox(width: 4),
                      const Text(
                        "Đang mở",
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.percent, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          "Giảm 32,000đ cho đơn từ 200,000đ",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildMenuSection(
                    "Phổ biến",
                    popularDishes,
                    horizontal: true,
                  ),
                  _buildMenuSection("Đặc biệt hôm nay", todaySpecial),
                  _buildMenuSection("Cơm phần (kèm cơm)", comboDishes),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- HÀM DỰNG SECTION ----------
  static Widget _buildMenuSection(
    String title,
    List<Map<String, dynamic>> dishes, {
    bool horizontal = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        horizontal
            ? SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: dishes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final dish = dishes[index];
                    return _buildDishCard(dish, width: 140);
                  },
                ),
              )
            : Column(
                children: dishes
                    .map(
                      (dish) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildDishCard(dish),
                      ),
                    )
                    .toList(),
              ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ---------- HÀM DỰNG CARD MÓN ----------
  static Widget _buildDishCard(
    Map<String, dynamic> dish, {
    double width = double.infinity,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              dish['image'],
              height: 100,
              width: width,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dish['name'],
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  "${dish['price']}đ • Cơm",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
