import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pickme_fe_app/core/common_services/format_money.dart';
import 'package:pickme_fe_app/features/merchant/model/menu.dart';
import 'package:pickme_fe_app/features/merchant/services/menu/menu_services.dart';

class RestaurantMenuPage extends StatefulWidget {
  final String restaurantId;
  final String token;

  const RestaurantMenuPage({
    super.key,
    required this.restaurantId,
    required this.token,
  });

  @override
  State<RestaurantMenuPage> createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage> {
  final MenuServices _menuServices = MenuServices();
  late Future<List<Menu>> _futureMenu;

  @override
  void initState() {
    super.initState();
    _loadMenus();
  }

  // Fetch api to get menu
  void _loadMenus() {
    _futureMenu = _menuServices.getMenu(widget.token, widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Menu>>(
      future: _futureMenu,
      builder: (context, snapshot) {
        // Icon when waiting for loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
        }

        final menuList = snapshot.data;

        // If dont have menu
        if (menuList == null || menuList.isEmpty) {
          // Empty menu
          return _buildEmptyMenuView(context);
        } else {
          // Menu list
          return _buildMenuListView(context, menuList);
        }
      },
    );
  }

  // Widget emty menu view
  Widget _buildEmptyMenuView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            // Icon add food
            Icon(Icons.fastfood_outlined, size: 60, color: Colors.grey[400]),

            const SizedBox(height: 12),

            // Title
            const Text(
              "Chưa có món ăn nào trong menu",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 8),

            // Btn add food
            ElevatedButton.icon(
              onPressed: () async {
                final result = await context.push(
                  "/merchant/restaurant/${widget.restaurantId}/create-menu",
                  extra: widget.token,
                );

                //If result == true reload screen
                if (result == true) {
                  setState(() {
                    _loadMenus();
                  });
                }
              },
              icon: const Icon(Icons.add),
              label: const Text("Thêm món đầu tiên"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget menu list view
  Widget _buildMenuListView(BuildContext context, List<Menu> menuList) {
    return ListView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), //Turn off scroll of menu list
      itemCount: menuList.length,
      itemBuilder: (context, index) {
        final menu = menuList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              // Food image
              child: Image.network(
                menu.imageUrl ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                // Error when image error
                errorBuilder: (context, _, __) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported, size: 28),
                ),
              ),
            ),
            // Food name
            title: Text(menu.name ?? "Không có tên"),

            // Food price
            subtitle: Text(
              UtilsMethod.formatMoney(menu.price ?? 0),
              style: const TextStyle(color: Colors.orange),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Mở chi tiết món ăn
            },
          ),
        );
      },
    );
  }
}
