import 'package:flutter/material.dart';
import 'package:pickme_fe_app/features/customer/widgets/order/order_history_tab.dart';
import '../../widgets/order/order_current_tab.dart';

class OrdersPage extends StatefulWidget {
  final String token;
  const OrdersPage({super.key, required this.token});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // number of tabs
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),

        // Appbar
        appBar: AppBar(
          title: const Text(
            "Đơn hàng",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),

            // Tab bar
            child: _buildTabs(),
          ),
        ),
        body: TabBarView(
          children: [
            // Order
            OrderCurrentTab(token: widget.token),

            // Order history
            OrderHistoryTab(token: widget.token),
          ],
        ),
      ),
    );
  }

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
