import 'package:flutter/material.dart';
import '../../widgets/home/custom_location_app_bar.dart';
import '../../widgets/home/category_horizontal_list.dart';
import '../../widgets/home/custom_nav_widget.dart';
import '../../widgets/home/public_restaurant_list.dart';

class Homepage extends StatefulWidget {
  final String token;

  const Homepage({super.key, required this.token});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedIndex = 0;

  void _onItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomLocationAppBar(),

            const SizedBox(height: 10),

            const CategoryHorizontalList(),

            const SizedBox(height: 10),

            CustomNavWidget(
              selectedIndex: selectedIndex,
              onItemSelected: _onItemSelected,
            ),
            if (selectedIndex == 0)
              const PublicRestaurantList()
            else
              const PublicRestaurantList(),
          ],
        ),
      ),
    );
  }
}
