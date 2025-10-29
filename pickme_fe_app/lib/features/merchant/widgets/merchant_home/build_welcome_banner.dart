import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';

class Buildwelcomebanner extends StatelessWidget {
  const Buildwelcomebanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // Title
                Text(
                  "Xin chào, Chủ quán",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 6),

                // Subtitle
                Text(
                  "Chúc bạn một ngày kinh doanh thuận lợi!",
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),

          // Icons
          const Icon(Icons.storefront, size: 48, color: Colors.orange),
        ],
      ),
    );
  }
}
