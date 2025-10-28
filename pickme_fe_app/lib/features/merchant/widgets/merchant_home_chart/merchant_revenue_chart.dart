import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MerchantRevenueChart extends StatefulWidget {
  const MerchantRevenueChart({super.key});

  @override
  State<MerchantRevenueChart> createState() => _MerchantRevenueChartState();
}

class _MerchantRevenueChartState extends State<MerchantRevenueChart> {
  List<double> revenues = [100, 120, 90, 160, 200, 180, 220];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text
        const Text(
          "Doanh thu 7 ngày gần đây",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        // Line chart
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              // Axis X have 7 points: Monday -> Sunday
              minX: 0,
              maxX: 6,

              // Axis y have 55 points: 0 -> 20
              minY: 0,
              maxY: 250,
              gridData: const FlGridData(show: true), //grid lines in chart
              borderData: FlBorderData(show: true), //border
              // Config for 4 axis
              titlesData: FlTitlesData(
                // Bottom axis
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final days = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"];

                      if (value.toInt() >= 0 && value.toInt() < days.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            days[value.toInt()],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),

                // Left axis
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 50,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
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

              // Display data
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
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
