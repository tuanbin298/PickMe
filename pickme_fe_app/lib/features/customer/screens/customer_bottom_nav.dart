import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerBottomNav extends StatefulWidget {
  final Widget child;
  final String? token;

  const CustomerBottomNav({super.key, required this.child, this.token});

  @override
  State<CustomerBottomNav> createState() => _CustomerBottomNavState();
}

class _CustomerBottomNavState extends State<CustomerBottomNav> {
  int _currentIndex = 0; // Track the currently selected tab index

  // Define routes corresponding to each bottom nav item
  final List<String> _routes = ['/home-page', '/orders', '/profile'];

  // Handle tab change when user taps a bottom nav item
  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() => _currentIndex = index);

      // Transmission token
      context.go(_routes[index], extra: widget.token);
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
          // Customer homepage
          BottomNavigationBarItem(
            icon: Icon(Icons.apps_outlined),
            activeIcon: Icon(Icons.apps),
            label: 'Trang chủ',
          ),

          // Customer order
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Đơn hàng',
          ),

          // Customer profile
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
