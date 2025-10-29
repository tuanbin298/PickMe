import 'package:flutter/material.dart';
import 'package:pickme_fe_app/features/customer/models/cart/cart.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant_menu.dart';
import 'package:pickme_fe_app/features/customer/services/cart/cart_service.dart';
import 'package:pickme_fe_app/features/customer/services/restaurant/restaurant_menu_service.dart';
import 'package:pickme_fe_app/features/customer/services/restaurant/restaurant_service.dart';
import 'package:pickme_fe_app/core/common_widgets/notification_service.dart';
import 'package:pickme_fe_app/features/customer/widgets/menu/addon_category_card.dart';
import 'package:pickme_fe_app/features/customer/widgets/menu/quantity_selector.dart';
import 'package:pickme_fe_app/features/customer/widgets/menu/bottom_price_bar.dart';

class RestaurantMenuDetailPage extends StatefulWidget {
  final String token;
  final int restaurantId;
  final int menuItemId;

  const RestaurantMenuDetailPage({
    super.key,
    required this.token,
    required this.restaurantId,
    required this.menuItemId,
  });

  @override
  State<RestaurantMenuDetailPage> createState() =>
      _RestaurantMenuDetailPageState();
}

class _RestaurantMenuDetailPageState extends State<RestaurantMenuDetailPage> {
  int quantity = 1;

  final Map<String, List<AddOn>> _addonsByCategory = {};
  final Map<String, Map<int, int>> _selections = {};

  bool _loading = true;
  bool _loadingAddToCart = false;
  String? _error;
  String? _specialNote;

  late Future<(Restaurant, RestaurantMenu)> _menuDataFuture;

  @override
  void initState() {
    super.initState();
    _menuDataFuture = _loadMenuDetail();
  }

  double get _addOnsTotal {
    double total = 0;
    _selections.forEach((catName, addons) {
      for (final entry in addons.entries) {
        final addon = _findAddonById(catName, entry.key);
        if (addon != null) total += addon.price * entry.value;
      }
    });
    return total;
  }

  AddOn? _findAddonById(String categoryName, int addonId) {
    final addons = _addonsByCategory[categoryName];
    if (addons == null) return null;
    try {
      return addons.firstWhere((a) => a.id == addonId);
    } catch (_) {
      return null;
    }
  }

  Future<(Restaurant, RestaurantMenu)> _loadMenuDetail() async {
    try {
      final restaurant = await RestaurantService().getRestaurantById(
        restaurantId: widget.restaurantId,
        token: widget.token,
      );
      final menu = await RestaurantMenuService().getMenuDetail(
        restaurantId: widget.restaurantId,
        menuItemId: widget.menuItemId,
        token: widget.token,
      );

      if (restaurant == null || menu == null) {
        throw Exception('Không tìm thấy dữ liệu món ăn hoặc nhà hàng.');
      }

      await _loadAddOnData();
      return (restaurant, menu);
    } catch (e) {
      debugPrint('Lỗi tải dữ liệu chi tiết món ăn: $e');
      throw Exception('Không thể tải thông tin món ăn');
    }
  }

  // Load AddOn data for the menu item
  Future<void> _loadAddOnData() async {
    try {
      final service = CartService();
      final response = await service.getAddOnsByMenuItem(
        token: widget.token,
        menuItemId: widget.menuItemId,
      );

      if (response == null) throw Exception('Không có dữ liệu AddOn');

      final allAddons = (response as List)
          .map((json) => AddOn.fromJson(json))
          .toList();

      _addonsByCategory.clear();
      for (final addon in allAddons) {
        _addonsByCategory.putIfAbsent(addon.category, () => []).add(addon);
      }

      setState(() => _loading = false);
    } catch (e) {
      debugPrint('Lỗi load AddOn: $e');
      setState(() {
        _error = 'Không thể tải AddOn';
        _loading = false;
      });
    }
  }

  // Handle adding the menu item to cart
  Future<void> _handleAddToCart(RestaurantMenu menu) async {
    setState(() => _loadingAddToCart = true);

    final List<Map<String, dynamic>> addOnsPayload = [];
    _selections.forEach((_, addons) {
      addons.forEach((addonId, qty) {
        addOnsPayload.add({'menuItemAddOnId': addonId, 'quantity': qty});
      });
    });

    try {
      final success = await CartService().addToCart(
        token: widget.token,
        restaurantId: widget.restaurantId,
        menuItemId: widget.menuItemId,
        quantity: quantity,
        specialInstructions: _specialNote,
        addOns: addOnsPayload,
      );

      if (success) {
        NotificationService.showSuccess(
          context,
          '${menu.name} x$quantity đã được thêm vào giỏ hàng!',
        );
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) Navigator.pop(context, true);
        });
      } else {
        NotificationService.showError(
          context,
          'Thêm vào giỏ thất bại, vui lòng thử lại.',
        );
      }
    } catch (e) {
      debugPrint('Add to cart error: $e');
      NotificationService.showError(context, 'Lỗi khi thêm vào giỏ hàng.');
    } finally {
      setState(() => _loadingAddToCart = false);
    }
  }

  // Toggle addon selection
  void _toggleAddon(String category, int addonId) {
    setState(() {
      _selections[category] ??= {};
      if (_selections[category]!.containsKey(addonId)) {
        _selections[category]!.remove(addonId);
      } else {
        _selections[category]![addonId] = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(Restaurant, RestaurantMenu)>(
      future: _menuDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Chi tiết món ăn')),
            body: Center(child: Text('Lỗi: ${snapshot.error}')),
          );
        }

        final (restaurant, menu) = snapshot.data!;
        final totalPrice = (menu.price + _addOnsTotal) * quantity;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text(_error!))
              : Column(
                  children: [
                    // Detail content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              child: Column(
                                children: [
                                  // Menu name and description
                                  Text(
                                    menu.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    menu.description,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Menu image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                menu.imageUrl.isNotEmpty
                                    ? menu.imageUrl
                                    : 'https://picsum.photos/seed/food/600/400',
                                width: double.infinity,
                                height: 240,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Addon categories
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                children: _addonsByCategory.entries
                                    .map(
                                      (entry) => AddonCategoryCard(
                                        category: entry.key,
                                        addons: entry.value,
                                        selections: _selections,
                                        onToggle: _toggleAddon,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            // Special note
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Ghi chú cho cửa hàng',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText:
                                          'Ví dụ: Ít cay, không hành, để riêng nước chấm...',
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      contentPadding: const EdgeInsets.all(12),
                                    ),
                                    maxLines: 3,
                                    onChanged: (v) => _specialNote = v,
                                  ),
                                  const SizedBox(height: 20),
                                  // Quantity selector
                                  QuantitySelector(
                                    quantity: quantity,
                                    onDecrease: () {
                                      if (quantity > 1) {
                                        setState(() => quantity--);
                                      }
                                    },
                                    onIncrease: () =>
                                        setState(() => quantity++),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                    // Bottom price bar
                    BottomPriceBar(
                      totalPrice: totalPrice,
                      loadingAddToCart: _loadingAddToCart,
                      onAddToCart: () => _handleAddToCart(menu),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
