import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pickme_fe_app/features/merchant/services/order/order_service.dart';
import 'package:pickme_fe_app/features/merchant/services/restaurant/restaurant_services.dart';

class MerchantOrderChart extends StatefulWidget {
  final String token;

  const MerchantOrderChart({super.key, required this.token});

  @override
  State<MerchantOrderChart> createState() => _MerchantOrderChartState();
}

class _MerchantOrderChartState extends State<MerchantOrderChart> {
  final OrderService _orderService = OrderService();
  final RestaurantServices _restaurantServices = RestaurantServices();

  // Store order status percent
  Map<String, double> orderStatusRatio = {};

  bool isLoading = true;

  // Store labels - color
  final Map<String, Color> statusColors = {
    "COMPLETED": Colors.green,
    "CANCELLED": Colors.red,
    "PENDING": Colors.orange,
    "CONFIRMED": Colors.blue,
  };

  final Map<String, String> statusLabels = {
    "COMPLETED": "Hoàn thành",
    "CANCELLED": "Đã hủy",
    "PENDING": "Chờ xác nhận",
    "CONFIRMED": "Đã xác nhận",
  };

  @override
  void initState() {
    super.initState();
    _loadOrderData();
  }

  // Method load data of order
  Future<void> _loadOrderData() async {
    try {
      // ---- 1. Get restaurants list ----
      final restaurants = await _restaurantServices.getRestaurantsByOwner(
        widget.token,
      );

      //2. ---- Get orders of specific restaurant ----
      final futures = restaurants.map(
        (restaurant) => _orderService.getAllOrdersOfRestaurant(
          widget.token,
          restaurant.id ?? 0,
        ),
      );
      final results = await Future.wait(futures);

      // Combine all orders
      final allOrders = results.expand((orders) => orders).toList();

      // Count the number of each state
      Map<String, int> statusCounts = {};
      for (var order in allOrders) {
        final status = order.status ?? "UNKNOWN";
        statusCounts[status] = (statusCounts[status] ?? 0) + 1;
      }

      // total number of orders
      final totalOrders = statusCounts.values.fold<int>(
        0,
        (sum, count) => sum + count,
      );

      // Calculate percentage by state
      Map<String, double> ratio = {};
      statusCounts.forEach((key, count) {
        if (totalOrders > 0) {
          ratio[key] = (count / totalOrders) * 100;
        }
      });

      setState(() {
        orderStatusRatio = ratio;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading order status: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Loading
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Empty
    if (orderStatusRatio.isEmpty) {
      return const Text("Chưa có dữ liệu đơn hàng");
    }

    final sections = _buildChartSections();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        const Text(
          "Tỉ lệ đơn hàng theo trạng thái",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        // Pie Chart
        Center(
          child: SizedBox(
            height: 220,
            width: 220,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Annotation state
        _buildAnnotate(),
      ],
    );
  }

  // Pie chart
  List<PieChartSectionData> _buildChartSections() {
    final List<PieChartSectionData> sections = [];

    // Loop in orderStatusRatio
    orderStatusRatio.forEach((key, value) {
      sections.add(
        PieChartSectionData(
          value: value,
          color: statusColors[key] ?? Colors.grey,
          title: '${value.toStringAsFixed(0)}%',
          radius: 55,
          titleStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    });

    return sections;
  }

  // Widget build annotate
  Widget _buildAnnotate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // Loop in orderStatusRatio
      children: orderStatusRatio.entries.map((entry) {
        final color = statusColors[entry.key] ?? Colors.grey;
        final label = statusLabels[entry.key] ?? entry.key;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),

              const SizedBox(width: 8),

              // Label
              Flexible(
                child: Text(
                  "$label (${entry.value.toStringAsFixed(1)}%)",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
