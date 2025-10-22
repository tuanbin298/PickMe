import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../customer/models/restaurant/restaurant.dart';
import '../../../customer/models/restaurant/restaurant_menu.dart';
import '../../../customer/services/restaurant/restaurant_menu_service.dart';
import '../../../customer/widgets/restaurant/restaurant_menu_tab.dart';

class RestaurantMenuPage extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantMenuPage({super.key, required this.restaurant});

  @override
  State<RestaurantMenuPage> createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage>
    with SingleTickerProviderStateMixin {
  late Future<List<RestaurantMenu>> _menusFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _menusFuture = _loadMenu();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<List<RestaurantMenu>> _loadMenu() async {
    final menuService = RestaurantMenuService();
    return await menuService.getPublicMenu(
      restaurantId: widget.restaurant.id,
      token: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = widget.restaurant;
    final imageUrl = restaurant.imageUrl.isNotEmpty
        ? restaurant.imageUrl
        : 'https://picsum.photos/seed/restaurant/800/400';

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<RestaurantMenu>>(
        future: _menusFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi tải menu: ${snapshot.error}'));
          }

          final menus = snapshot.data ?? [];

          return RestaurantMenuTabView(
            restaurant: restaurant,
            menus: menus,
            tabController: _tabController,
            onRefresh: () async {
              setState(() => _menusFuture = _loadMenu());
              await _menusFuture;
            },
            // Handle menu item tap
            onTap: (menu) {
              context.pushNamed(
                'restaurant-menu-detail',
                pathParameters: {'restaurantId': restaurant.id.toString()},
                extra: {
                  'name': menu.name,
                  'description': menu.description,
                  'imageUrl': menu.imageUrl ?? '',
                  'price': menu.price,
                },
              );
            },
          );
        },
      ),
    );
  }
}
