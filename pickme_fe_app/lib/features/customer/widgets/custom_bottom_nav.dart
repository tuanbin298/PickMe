import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Custom bottom navigation bar widget
class CustomBottomNav extends StatelessWidget {
  final int selectedIndex; // current selected tab
  final Function(int) onItemSelected; // callback when a tab is tapped

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Navigation items: first one is custom "dots", others are icons
    final items = [
      {"type": "dots"},
      {"icon": Icons.receipt_long},
      {"icon": Icons.person},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          // light shadow above the bar
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              onItemSelected(index);
              // Navigate to different pages based on index
              if (index == 2) {
                context.goNamed("profile");
              } else if (index == 1) {
                context.goNamed("orders");
              } else {
                context.goNamed("home");
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (index == 0)
                  // First item: special "4 dots" icon
                  Row(
                    children: List.generate(2, (i) {
                      return Column(
                        children: List.generate(2, (j) {
                          // Highlight only top-left dot when selected
                          final isActive = isSelected && i == 0 && j == 0;
                          return Container(
                            margin: const EdgeInsets.all(2),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.orange
                                  : Colors.grey[400],
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      );
                    }),
                  )
                else
                  // Other items: normal icon
                  Icon(
                    items[index]["icon"] as IconData,
                    size: 28,
                    color: isSelected ? Colors.orange : Colors.grey[400],
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
