import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String avatarUrl;

  const ProfileHeader({super.key, required this.name, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          CircleAvatar(radius: 40, backgroundImage: NetworkImage(avatarUrl)),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
