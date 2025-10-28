import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../customer/models/restaurant/restaurant.dart';
import '../../../customer/models/restaurant/restaurant_menu.dart';
import '../../../customer/services/restaurant/restaurant_menu_service.dart';
import 'package:pickme_fe_app/features/customer/widgets/restaurant/restaurant_menu_tab_view.dart';
import 'package:pickme_fe_app/core/common_services/utils_method.dart';

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

  // Method get menu of restaurant
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
    final bool isClosed = !restaurant.isOpen;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<List<RestaurantMenu>>(
          future: _menusFuture,
          builder: (context, snapshot) {
            // Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Error
            if (snapshot.hasError) {
              return Center(child: Text('Lỗi tải menu: ${snapshot.error}'));
            }

            final menus = snapshot.data ?? [];

            return Column(
              // Main content
              children: [
                Expanded(
                  // Menu Tab View
                  child: RestaurantMenuTabView(
                    restaurant: restaurant,
                    menus: menus,
                    tabController: _tabController,

                    // Refresh when user scroll down
                    onRefresh: () async {
                      final newMenusFuture = _loadMenu();

                      setState(() {
                        _menusFuture = newMenusFuture;
                      });
                      await newMenusFuture;
                    },

                    onTap: (menu) {
                      // if (isClosed) return;
                      context.pushNamed(
                        'restaurant-menu-detail',
                        pathParameters: {
                          'restaurantId': restaurant.id.toString(),
                        },
                        extra: {
                          'name': menu.name,
                          'description': menu.description,
                          'imageUrl': menu.imageUrl,
                          'price': menu.price,
                        },
                      );
                    },
                    unavailable: isClosed,
                  ),
                ),

                // Notify user if restaurant is closed
                if (isClosed)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),

                    // Closed notification
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Clock Icon
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.access_time_filled_rounded,
                            color: Colors.orange.shade600,
                            size: 22,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Closed message
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Cửa hàng tạm ngưng nhận đơn',
                                style: TextStyle(
                                  color: Colors.orange.shade800,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                'Sẽ mở lại vào ${UtilsMethod.formatTime(restaurant.openingTime)}.',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
