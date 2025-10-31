import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RestaurantNavigateBottom extends StatefulWidget {
  final Widget child;
  final String restaurantId;
  final String? token;

  const RestaurantNavigateBottom({
    super.key,
    required this.child,
    required this.restaurantId,
    this.token,
  });

  @override
  State<RestaurantNavigateBottom> createState() =>
      _RestaurantNavigateBottomState();
}

class _RestaurantNavigateBottomState extends State<RestaurantNavigateBottom> {
  int _currentIndex = 0;

  late final List<String> _routes;

  // Attach id into routes
  @override
  void initState() {
    super.initState();
    _routes = [
      '/merchant/restaurant/${widget.restaurantId}/detail',
      '/merchant/restaurant/${widget.restaurantId}/orders',
      '/merchant/restaurant/${widget.restaurantId}/feedbacks',
    ];
  }

  // Hanlde when user tap navigate bottom
  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() => _currentIndex = index);

      // Transmission token
      context.push(_routes[index], extra: widget.token);
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
          // Detail
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            activeIcon: Icon(Icons.storefront),
            label: 'Chi tiết',
          ),

          // Order
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Đơn hàng',
          ),

          // Feedback
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Đánh giá',
          ),
        ],
      ),
    );
  }
}
