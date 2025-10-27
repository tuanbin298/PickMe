import 'package:flutter/material.dart';
import '../../models/order/order.dart';
import '../../services/order/order_service.dart';
import '../../widgets/order/order_current_tab.dart';
import '../../widgets/order/order_history_tab.dart';

class OrdersPage extends StatefulWidget {
  final String token;
  const OrdersPage({super.key, required this.token});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<OrderModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = OrderService().getOrderHistory();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // number of tabs
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: _buildSearchBar(),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: _buildTabs(),
          ),
        ),
        body: TabBarView(
          children: [
            const OrderCurrentTab(),
            OrderHistoryTab(ordersFuture: _ordersFuture),
          ],
        ),
      ),
    );
  }

  // Thanh tìm kiếm
  Widget _buildSearchBar() => Container(
    height: 40,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(10),
    ),
    child: const Row(
      children: [
        Icon(Icons.location_on_outlined, color: Colors.grey, size: 18),
        SizedBox(width: 6),
        Text(
          "Tìm địa điểm",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    ),
  );

  // Tabs
  Widget _buildTabs() => Container(
    alignment: Alignment.center,
    child: const TabBar(
      labelColor: Colors.orange,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.orange,
      indicatorWeight: 2,
      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      tabs: [
        Tab(text: "Đơn hiện tại"),
        Tab(text: "Lịch sử"),
      ],
    ),
  );
}
