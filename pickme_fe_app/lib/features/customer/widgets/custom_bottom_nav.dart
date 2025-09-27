import 'package:flutter/material.dart';

class CustomNavWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomNavWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = ["Dọc tuyến đường", "Giảm giá"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(items.length, (index) {
        final isSelected = index == selectedIndex;
        return GestureDetector(
          onTap: () => onItemSelected(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Text(
              items[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.orange : Colors.grey,
              ),
            ),
          ),
        );
      }),
    );
  }
}
