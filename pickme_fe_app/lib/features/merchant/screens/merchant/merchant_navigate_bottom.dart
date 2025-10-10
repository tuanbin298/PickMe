import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MerchantNavigateBottom extends StatefulWidget {
  final Widget child;
  final String? token;

  const MerchantNavigateBottom({super.key, required this.child, this.token});

  @override
  State<MerchantNavigateBottom> createState() => _MerchantNavigateBottomState();
}

class _MerchantNavigateBottomState extends State<MerchantNavigateBottom> {
  int _currentIndex = 0;

  // List string for routes
  final List<String> _routes = [
    '/merchant-homepage',
    '/merchant-restaurant-list',
    '/merchant-profile',
  ];

  // Hanlde when user tap navigate bottom
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
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        // UI
        items: const [
          // Homepage
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),

          // List restaurant
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined),
            activeIcon: Icon(Icons.restaurant),
            label: 'Nhà hàng',
          ),

          // Profile
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
