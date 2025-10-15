import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';

class CustomLocationAppBar extends StatefulWidget {
  final String? destination;
  const CustomLocationAppBar({super.key, this.destination});

  @override
  State<CustomLocationAppBar> createState() => _CustomLocationAppBarState();
}

class _CustomLocationAppBarState extends State<CustomLocationAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Lộ trình của bạn",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff172B4D),
                  ),
                ),

                // Button to watch MAP
                IconButton(
                  icon: const Icon(Icons.map, color: AppColors.primary),
                  onPressed: () {
                    context.push('/map');
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Route display (current location and destination)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side (icons)
                Column(
                  children: [
                    // Icon
                    const Icon(
                      Icons.my_location,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    // If destination is null, then only show current location
                    if (widget.destination != null) ...[
                      const SizedBox(height: 4),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          3,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 20,
                      ),
                    ],
                  ],
                ),

                const SizedBox(width: 8),

                // Right side (Text)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Vị trí hiện tại",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff172B4D),
                        ),
                      ),

                      // Divider
                      const Divider(),

                      // show destination if have
                      if (widget.destination != null)
                        Text(
                          widget.destination!,
                          style: const TextStyle(
                            fontSize: 16,
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
