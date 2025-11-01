import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/home/custom_location_app_bar.dart';
import '../../widgets/home/public_restaurant_list.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';

class Homepage extends StatefulWidget {
  final String token;

  const Homepage({super.key, required this.token});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Nút giỏ hàng nằm đè lên nội dung cuộn
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header vị trí
                  const CustomLocationAppBar(),
                  const SizedBox(height: 10),

                  // Thanh chọn danh mục
                  CustomNavWidget(
                    selectedIndex: selectedIndex,
                    onItemSelected: _onItemSelected,
                  ),

                  // Danh sách nhà hàng công khai
                  PublicRestaurantList(token: widget.token),
                ],
              ),
            ),
          ),

          // === 🛒 Floating Cart Button ===
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton.extended(
              backgroundColor: AppColors.primary,
              onPressed: () {
                // Điều hướng sang trang giỏ hàng với token
                context.push('/cart-overview', extra: widget.token);
              },
              label: const Text(
                "Giỏ hàng",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
