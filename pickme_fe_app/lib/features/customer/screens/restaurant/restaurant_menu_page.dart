import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../customer/models/restaurant/restaurant.dart';
import '../../../customer/models/restaurant/restaurant_menu.dart';
import '../../../customer/services/restaurant/restaurant_menu_service.dart';
import 'package:pickme_fe_app/features/customer/widgets/restaurant/restaurant_menu_tab_view.dart';
import 'package:pickme_fe_app/core/common_services/utils_method.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import '../../../customer/services/cart/cart_service.dart';
import '../../../customer/models/cart/cart.dart';

class RestaurantMenuPage extends StatefulWidget {
  final Restaurant restaurant;
  final String token;
  const RestaurantMenuPage({
    super.key,
    required this.restaurant,
    required this.token,
  });

  @override
  State<RestaurantMenuPage> createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // ✅ Giữ lại trạng thái khi quay lại

  late Future<List<RestaurantMenu>> _menusFuture;
  late TabController _tabController;

  final CartService _cartService = CartService();
  int _cartItemCount = 0;
  double _cartTotal = 0.0;
  bool _isCartLoading = true;

  @override
  void initState() {
    super.initState();
    _menusFuture = _loadMenu();
    _loadCartData();
    _tabController = TabController(length: 2, vsync: this);
  }

  // Method get menu of restaurant
  Future<List<RestaurantMenu>> _loadMenu() async {
    final menuService = RestaurantMenuService();

    return await menuService.getPublicMenu(
      restaurantId: widget.restaurant.id,
      token: widget.token,
    );
  }

  // ✅ Method get cart total and item count
  Future<void> _loadCartData() async {
    if (!mounted) return;

    setState(() {
      _isCartLoading = true;
    });

    try {
      final results = await Future.wait([
        _cartService.getCartItemCount(
          token: widget.token,
          restaurantId: widget.restaurant.id,
        ),
        _cartService.getCartTotal(
          token: widget.token,
          restaurantId: widget.restaurant.id,
        ),
      ]);

      final count = results[0] ?? 0;
      final total = results[1] ?? 0.0;

      if (mounted) {
        setState(() {
          _cartItemCount = count.toInt();
          _cartTotal = total.toDouble();
          _isCartLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCartLoading = false;
          _cartItemCount = 0;
          _cartTotal = 0.0;
        });
        debugPrint("❌ Lỗi tải dữ liệu giỏ hàng: $e");
      }
    }
  }

  // Trong RestaurantMenuPage
  Future<List<CartItem>> _getCartItems() async {
    try {
      final cartData = await _cartService.getCartByRestaurantId(
        token: widget.token,
        restaurantId: widget.restaurant.id,
      );

      if (cartData == null) return [];

      final cart = Cart.fromJson(cartData);
      return cart.cartItems;
    } catch (e) {
      debugPrint("Lỗi: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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

            return Stack(
              children: [
                // Main content
                Positioned.fill(
                  top: isClosed ? 55 : 0,
                  child: RestaurantMenuTabView(
                    restaurant: restaurant,
                    menus: menus,
                    tabController: _tabController,
                    token: widget.token,

                    // Refresh when user scroll down
                    onRefresh: () async {
                      final newMenusFuture = _loadMenu();
                      await _loadCartData(); // Refresh cart data as well

                      setState(() {
                        _menusFuture = newMenusFuture;
                      });
                      await newMenusFuture;
                    },

                    onTap: (menu) async {
                      if (isClosed) return;

                      final result = await context.pushNamed(
                        'restaurant-menu-detail',
                        pathParameters: {'menuItemId': menu.id.toString()},
                        extra: {
                          'name': menu.name,
                          'description': menu.description,
                          'imageUrl': menu.imageUrl,
                          'price': menu.price,
                        },
                      );

                      // Refresh cart data when returning from detail page
                      if (result == true && mounted) {
                        await _loadCartData();
                      }
                    },
                    unavailable: isClosed,
                  ),
                ),

                // Notify user if restaurant is closed
                if (isClosed)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.orange.shade100,
                            width: 1,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Cart background container
                if (!_isCartLoading && _cartItemCount > 0)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(height: 90, color: Colors.white),
                  ),

                // Cart button
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: GestureDetector(
                      onTap: isClosed
                          ? null // Disable the cart button when the restaurant is closed
                          : () async {
                              final cartData = await _cartService
                                  .getCartByRestaurantId(
                                    token: widget.token,
                                    restaurantId: widget.restaurant.id,
                                  );

                              if (cartData == null ||
                                  (cartData['cartItems'] as List).isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Giỏ hàng trống!"),
                                  ),
                                );
                                return;
                              }

                              final cart = Cart.fromJson(cartData);

                              context.pushNamed(
                                'cart',
                                extra: {
                                  'token': widget.token,
                                  'restaurant': cart.restaurant,
                                  'cartItems': cart.cartItems,
                                  'total': cart.totalAmount,
                                },
                              );
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isClosed ? Colors.grey : AppColors.primary,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                const SizedBox(width: 10),
                                // Item Count
                                Text(
                                  'Giỏ hàng ($_cartItemCount)',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            // Total Price
                            Text(
                              UtilsMethod.formatMoney(_cartTotal),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
