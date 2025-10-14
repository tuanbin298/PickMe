import 'package:flutter/material.dart';

class CategoryHorizontalList extends StatefulWidget {
  const CategoryHorizontalList({super.key});

  @override
  State<CategoryHorizontalList> createState() => _CategoryHorizontalListState();
}

class _CategoryHorizontalListState extends State<CategoryHorizontalList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
          top: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 0, top: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row: "Danh mục" on the left, "Tất cả" on the right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Danh mục", // "Category"
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff172B4D),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Text(
                    "Tất cả", // "All"
                    style: TextStyle(fontSize: 18, color: Color(0xff172B4D)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Divider line
            const Divider(),

            const SizedBox(height: 20),

            // Horizontal list of categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryItem(
                    "lib/assets/images/category_item.png",
                    "Cơm", // "Rice"
                  ),
                  _buildCategoryItem(
                    "lib/assets/images/category_item.png",
                    "Bún-Phở-Cháo", // "Noodles - Pho - Porridge"
                  ),
                  _buildCategoryItem(
                    "lib/assets/images/category_item.png",
                    "Nước uống", // "Drinks"
                  ),
                  _buildCategoryItem(
                    "lib/assets/images/category_item.png",
                    "Khác", // "Others"
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build one category item
  static Widget _buildCategoryItem(String imagePath, String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          // Circle image
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 36,
              backgroundImage: AssetImage(imagePath), // Load asset image
            ),
          ),

          const SizedBox(height: 8),

          // Category name
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Color(0xff172B4D)),
          ),
        ],
      ),
    );
  }
}
