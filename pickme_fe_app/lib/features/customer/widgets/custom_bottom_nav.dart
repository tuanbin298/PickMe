import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNav extends StatefulWidget {
  final Widget child; // The main content displayed above the bottom navigation
  final String? token; // Optional token passed between pages

  const CustomBottomNav({super.key, required this.child, this.token});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int _currentIndex = 0; // Track the currently selected tab index

  // Define routes corresponding to each bottom nav item
  final List<String> _routes = ['/home-page', '/orders', '/profile'];

  // Handle tab change when user taps a bottom nav item
  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() => _currentIndex = index);
      context.go(_routes[index], extra: widget.token); // Navigate to new route
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child, // Display the page content
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.orange, // Highlighted icon color
        unselectedItemColor: Colors.grey, // Unselected icon color
        showUnselectedLabels: false, // Hide labels for unselected items
        type: BottomNavigationBarType.fixed, // Prevent shifting animation
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.apps_outlined),
            activeIcon: Icon(Icons.apps),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Đơn hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ],
      ),
    );
  }
}
