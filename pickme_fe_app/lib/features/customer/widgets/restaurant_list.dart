import 'package:flutter/material.dart';

// Restaurant data model
class Restaurant {
  final String name;
  final String image;
  final String status;
  final double rating;
  final String distance;
  final String tags;

  Restaurant({
    required this.name,
    required this.image,
    required this.status,
    required this.rating,
    required this.distance,
    required this.tags,
  });
}

// Widget that displays a list of restaurants
class RestaurantList extends StatelessWidget {
  const RestaurantList({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock restaurant data
    final restaurants = [
      Restaurant(
        name: "Quán cơm chú Cuội",
        image: "lib/assets/images/category_item.png",
        status: "Đang mở",
        rating: 4.8,
        distance: "2.6 km",
        tags: "Cơm · Mì · Nước ngọt",
      ),
      Restaurant(
        name: "Bánh canh ghẹ DHL",
        image: "lib/assets/images/category_item.png",
        status: "Đang mở",
        rating: 4.0,
        distance: "3.0 km",
        tags: "Bánh canh · Hải sản · Nước ngọt",
      ),
    ];

    return ListView.builder(
      itemCount: restaurants.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = restaurants[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            // Card style (white background + shadow + rounded corners)
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant image
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      item.image,
                      height: 140, // smaller height
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Restaurant info
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + verified icon
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff172B4D),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.verified,
                            color: Colors.green,
                            size: 18,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Status + Tags
                      Row(
                        children: [
                          Text(
                            item.status,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: item.status == "Đang mở"
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item.tags,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Rating + Distance + Price icon
                      Row(
                        children: [
                          // Rating badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item.rating.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Distance
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.distance,
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 12),
                          // Price (just an icon for now)
                          const Icon(
                            Icons.attach_money,
                            size: 14,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
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
