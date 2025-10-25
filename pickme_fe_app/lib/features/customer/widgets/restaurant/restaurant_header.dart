import 'package:flutter/material.dart';

class RestaurantHeader extends StatelessWidget {
  final String? imageUrl;
  const RestaurantHeader({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // Display restaurant header image
    return Image.network(
      imageUrl ?? 'https://via.placeholder.com/600x200',
      fit: BoxFit.cover,
      width: double.infinity,
      height: 200,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey.shade200,
        child: const Icon(
          Icons.image_not_supported,
          size: 60,
          color: Colors.grey,
        ),
      ),
    );
  }
}
