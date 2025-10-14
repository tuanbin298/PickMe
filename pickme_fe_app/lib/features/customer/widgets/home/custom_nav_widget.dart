import 'package:flutter/material.dart';

// Custom navigation bar widget
class CustomNavWidget extends StatelessWidget {
  final int selectedIndex; // current selected tab
  final Function(int) onItemSelected; // callback when user taps a tab

  const CustomNavWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    // List of navigation items (text only)
    final items = ["Dọc tuyến đường", "Giảm giá"];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(items.length, (index) {
          final isSelected = index == selectedIndex; // check if active tab
          return GestureDetector(
            onTap: () => onItemSelected(index), // call parent callback
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    // underline only if selected
                    color: isSelected ? Colors.orange : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                items[index],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.orange : Colors.grey,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
