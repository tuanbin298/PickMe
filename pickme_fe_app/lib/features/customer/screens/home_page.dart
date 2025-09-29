import 'package:flutter/material.dart';
import '../widgets/custom_location_app_bar.dart';
import '../widgets/category_horizontal_list.dart';
import '../widgets/custom_nav_widget.dart';
import '../widgets/restaurant_list.dart';
import '../widgets/custom_bottom_nav.dart';

// Homepage with top location bar, categories, tabs, restaurant list, and bottom nav
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedIndex = 0; // index for top tab navigation
  int bottomNavIndex = 0; // index for bottom navigation

  // Handle top tab navigation change
  void _onItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // Handle bottom navigation change
  void _onBottomNavSelected(int index) {
    setState(() {
      bottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top app bar: location selector
              const CustomLocationAppBar(),

              const SizedBox(height: 10),

              /// Horizontal category list
              const CategoryHorizontalList(),

              const SizedBox(height: 10),

              /// Custom top tab navigation ("Along the route / Discounts")
              CustomNavWidget(
                selectedIndex: selectedIndex,
                onItemSelected: _onItemSelected,
              ),

              /// Tab content: restaurant list
              if (selectedIndex == 0)
                const RestaurantList()
              else
                const RestaurantList(),
            ],
          ),
        ),
      ),

      /// Custom bottom navigation bar
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: bottomNavIndex,
        onItemSelected: _onBottomNavSelected,
      ),
    );
  }
}
