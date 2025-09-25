import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';

class CustomLocationAppBar extends StatefulWidget {
  const CustomLocationAppBar({super.key});

  @override
  State<CustomLocationAppBar> createState() => _CustomLocationAppBarState();
}

class _CustomLocationAppBarState extends State<CustomLocationAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20), // round only bottom corners
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 30,
          right: 30,
          top: 30,
          bottom: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Lộ trình của bạn",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff172B4D),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // left side (icons)
                Column(
                  children: [
                    Icon(
                      Icons.radio_button_unchecked,
                      color: Colors.grey,
                      size: 20,
                    ),
                    SizedBox(height: 4),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        3,
                        (index) => Container(
                          margin: EdgeInsets.symmetric(vertical: 2),
                          width: 3,
                          height: 3,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Icon(Icons.location_on, color: AppColors.primary, size: 20),
                  ],
                ),

                const SizedBox(width: 8),

                // right side (texts)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Vị trí hiện tại",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff172B4D),
                        ),
                      ),
                      const Divider(),
                      Text(
                        "Đại học FPT HCM",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: "Tìm món ăn",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xffF5F6F7),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
