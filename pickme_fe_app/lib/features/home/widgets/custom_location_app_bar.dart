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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title section
          const Text(
            "Lộ trình của bạn",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff172B4D),
            ),
          ),
          const SizedBox(height: 16),

          // Main Row: icons on the left, texts on the right
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column for icons (radio -> dots -> location)
              Column(
                children: [
                  // Circle radio icon for "current position"
                  Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.grey,
                    size: 20,
                  ),

                  // Dotted line between two steps
                  Container(
                    height: 24,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        3,
                        (index) => Container(
                          width: 3,
                          height: 3,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 229, 221, 221),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Location pin icon for "destination"
                  Icon(Icons.location_on, color: AppColors.primary, size: 20),
                ],
              ),
              const SizedBox(width: 8),

              // Right column for texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current position text
                    const Text(
                      "Vị trí hiện tại",
                      style: TextStyle(fontSize: 16, color: Color(0xff172B4D)),
                    ),
                    const Divider(
                      color: Color.fromARGB(255, 229, 221, 221),
                    ), // Horizontal divider line
                    // Destination text
                    Text(
                      "Đại học FPT HCM",
                      style: TextStyle(fontSize: 16, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
