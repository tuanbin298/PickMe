import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickme_fe_app/core/common_services/utils_method.dart';
import 'package:pickme_fe_app/features/merchant/services/order/order_service.dart';
import 'package:pickme_fe_app/features/merchant/services/restaurant/restaurant_services.dart';

class MerchantRevenueChart extends StatefulWidget {
  final String token;

  const MerchantRevenueChart({super.key, required this.token});

  @override
  State<MerchantRevenueChart> createState() => _MerchantRevenueChartState();
}

class _MerchantRevenueChartState extends State<MerchantRevenueChart> {
  final OrderService _orderService = OrderService();
  final RestaurantServices _restaurantServices = RestaurantServices();

  // List revenues of last 7 days
  List<double> revenues = List.filled(7, 0);

  // Display days format dd/MM
  late List<String> displayDays;

  // Key format yyyy-MM-dd
  late List<String> dateKeys; // key thật yyyy-MM-dd

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Method load data of order
  Future<void> _loadData() async {
    try {
      // ---- 1. Get restaurants list ----
      final restaurants = await _restaurantServices.getRestaurantsByOwner(
        widget.token,
      );

      // ---- 2. Create list of last 7 days ----
      final now = DateTime.now();
      final start = now.subtract(
        const Duration(days: 6),
      ); //Take the current date and subtract 6 days.

      //2.1 Create 2 list

      //List of last 7 days follow format yyyy-MM-dd (key in dailyRevenue)
      dateKeys = List.generate(
        7,
        (i) => DateFormat('yyyy-MM-dd').format(start.add(Duration(days: i))),
      );

      // List of last 7 days follow format dd/MM (display in chart)
      displayDays = List.generate(
        7,
        (i) => DateFormat('dd/MM').format(start.add(Duration(days: i))),
      );

      //3. ---- Create MAP to store revenue per days (key: dateKeys)----
      Map<String, double> dailyRevenue = {for (var key in dateKeys) key: 0};

      //4. ---- Get orders of specific restaurant ----
      final futures = restaurants.map(
        (restaurant) => _orderService.getAllOrdersOfRestaurant(
          widget.token,
          restaurant.id ?? 0,
        ),
      );
      final results = await Future.wait(futures);

      // 5. Loop in orders to results to synthetic revenue per day (field: createdAt, totalAmount)
      for (var orders in results) {
        for (var order in orders) {
          if (order.createdAt == null || order.totalAmount == null) continue;
          final dateStr = DateFormat('yyyy-MM-dd').format(order.createdAt!);
          if (dailyRevenue.containsKey(dateStr)) {
            dailyRevenue[dateStr] =
                (dailyRevenue[dateStr] ?? 0) + (order.totalAmount ?? 0);
          }
        }
      }

      // Translate map into list<double> to draw chart
      // dailyRevenue contain revenue
      // dateKeys contain date
      setState(() {
        revenues = dateKeys
            .map(
              (key) => ((dailyRevenue[key] ?? 0).clamp(
                0,
                double.infinity,
              )).toDouble(),
            )
            .toList();

        isLoading = false;
      });

      // print(revenues);
    } catch (e) {
      print('Error loading revenue: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Loading
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // The highest revenue to calculate axis Y
    final maxRevenue = revenues.isNotEmpty
        ? revenues.reduce((a, b) => a > b ? a : b)
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        const Text(
          "Doanh thu 7 ngày gần đây",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        // Chart UI
        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              minX: 0,
              //Bottom axis
              maxX: 6,
              minY: 0,
              // Left axis
              maxY: maxRevenue + (maxRevenue > 0 ? maxRevenue * 0.2 : 100),
              gridData: const FlGridData(show: true), //Show grid line in chart
              // Bottom axis
              borderData: FlBorderData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= displayDays.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 4.0),

                        // Display date
                        child: Text(
                          displayDays[i],
                          style: const TextStyle(fontSize: 11),
                        ),
                      );
                    },
                  ),
                ),

                // Left axis
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    interval: (maxRevenue / 4).clamp(1, double.infinity),
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Text(
                          UtilsMethod.formatMoney(value),
                          style: const TextStyle(fontSize: 6),
                        ),
                      );
                    },
                  ),
                ),

                // Top axis
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),

                // Right axis
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),

              // Tooltip when user touch
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.black87,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      return LineTooltipItem(
                        '${displayDays[spot.x.toInt()]}: ${UtilsMethod.formatMoney(spot.y)}',
                        const TextStyle(color: Colors.white),
                      );
                    }).toList();
                  },
                ),
              ),

              // Line char
              lineBarsData: [
                LineChartBarData(
                  color: Colors.green,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.green.withOpacity(0.2),
                  ),
                  dotData: const FlDotData(show: false),
                  spots: List.generate(
                    revenues.length,
                    (i) => FlSpot(i.toDouble(), revenues[i]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
