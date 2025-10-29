import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/common_services/utils_method.dart';
import 'package:pickme_fe_app/features/customer/models/cart/cart.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant_menu.dart';
import 'package:pickme_fe_app/features/customer/services/cart/cart_service.dart';
import 'package:pickme_fe_app/features/customer/services/restaurant/restaurant_menu_service.dart';
import 'package:pickme_fe_app/features/customer/services/restaurant/restaurant_service.dart';
import 'package:pickme_fe_app/core/common_widgets/notification_service.dart';

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

  /// Dạng: categoryName → danh sách AddOn
  final Map<String, List<AddOn>> _addonsByCategory = {};

  /// Dạng: categoryName → addonId → qty
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
        if (addon != null) {
          total += addon.price * entry.value;
        }
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

      // group by category
      _addonsByCategory.clear();
      for (final addon in allAddons) {
        _addonsByCategory.putIfAbsent(addon.category, () => []).add(addon);
      }

      setState(() {
        _loading = false;
      });
    } catch (e) {
      debugPrint('Lỗi load AddOn: $e');
      setState(() {
        _error = 'Không thể tải AddOn';
        _loading = false;
      });
    }
  }

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

        // 🟢 Quay lại trang trước (Menu)
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
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 🟧 Tên và mô tả món
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    menu.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
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
                            // 🟧 Ảnh món ăn
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

                            // 🟩 Addons
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                children: _addonsByCategory.entries
                                    .map(
                                      (entry) => _buildCategoryCard(
                                        entry.key,
                                        entry.value.toList(),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),

                            // 🟦 Ghi chú + Số lượng
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
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.all(12),
                                    ),
                                    maxLines: 3,
                                    onChanged: (v) => _specialNote = v,
                                  ),
                                  const SizedBox(height: 20),

                                  // ✅ Điều khiển số lượng đưa lên đây
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Nút trừ
                                      InkWell(
                                        onTap: quantity > 1
                                            ? () => setState(() => quantity--)
                                            : null,
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.orange,
                                              width: 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.orange
                                                    .withOpacity(0.1),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.remove,
                                            color: Colors.orange,
                                            size: 28,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 20),

                                      // Số lượng
                                      Text(
                                        '$quantity',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),

                                      const SizedBox(width: 20),

                                      // Nút cộng
                                      InkWell(
                                        onTap: () => setState(() => quantity++),
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.orange,
                                              width: 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.orange
                                                    .withOpacity(0.1),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.orange,
                                            size: 28,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),

                    // 🟨 Thanh giá + nút thêm giỏ hàng
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Giá',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    UtilsMethod.formatMoney(totalPrice),
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 200,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _loadingAddToCart
                                      ? null
                                      : () async => _handleAddToCart(menu),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _loadingAddToCart
                                      ? const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          'Thêm vào giỏ hàng',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildHeader(RestaurantMenu menu) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              menu.imageUrl.isNotEmpty
                  ? menu.imageUrl
                  : 'https://picsum.photos/seed/food/160/160',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 120,
                height: 120,
                color: Colors.grey.shade200,
                child: const Icon(Icons.fastfood, size: 48, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menu.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                if (menu.description.isNotEmpty)
                  Text(
                    menu.description,
                    style: const TextStyle(color: Colors.grey),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      UtilsMethod.formatMoney(menu.price),
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: quantity > 1
                                ? () => setState(() => quantity--)
                                : null,
                            icon: const Icon(Icons.remove),
                          ),
                          Text(
                            '$quantity',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () => setState(() => quantity++),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String category, List<AddOn> addons) {
    // ✅ Giả định: AddOn có thuộc tính `isRequired` để xác định bắt buộc / không bắt buộc
    final bool isRequired = addons.isNotEmpty && (addons.first.isRequired);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =============================
          // 🟧 PHẦN HEADER CỦA CATEGORY
          // =============================
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Hiển thị nhãn "Bắt buộc" hoặc "Không bắt buộc"
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isRequired ? Colors.red.shade50 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isRequired ? 'Bắt buộc' : 'Không bắt buộc',
                  style: TextStyle(
                    color: isRequired ? Colors.redAccent : Colors.grey[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // =============================
          // 🟦 ĐƯỜNG KẺ NGĂN CÁCH
          // =============================
          Divider(color: Colors.grey.shade300, thickness: 1, height: 20),

          // =============================
          // 🟩 DANH SÁCH ADDON
          // =============================
          ...addons.map((addon) {
            final selected = _selections[category]?[addon.id] != null ?? false;
            return InkWell(
              onTap: () => _toggleAddon(category, addon.id),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Checkbox(
                      value: selected,
                      onChanged: (_) => _toggleAddon(category, addon.id),
                    ),
                    Expanded(
                      child: Text(
                        '${addon.name} (${UtilsMethod.formatMoney(addon.price)})',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

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

  Widget _buildBottomBar(RestaurantMenu menu, double totalPrice) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tổng giá', style: TextStyle(color: Colors.grey)),
                Text(
                  UtilsMethod.formatMoney(totalPrice),
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 170,
            height: 48,
            child: ElevatedButton(
              onPressed: _loadingAddToCart
                  ? null
                  : () async => _handleAddToCart(menu),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _loadingAddToCart
                  ? const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    )
                  : const Text(
                      'Thêm vào giỏ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
