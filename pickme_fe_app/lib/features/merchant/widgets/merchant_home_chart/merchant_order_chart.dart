import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MerchantOrderChart extends StatefulWidget {
  const MerchantOrderChart({super.key});

  @override
  State<MerchantOrderChart> createState() => _MerchantOrderChartState();
}

class _MerchantOrderChartState extends State<MerchantOrderChart> {
  final Map<String, double> orderStatus = {
    "Hoàn thành": 45,
    "Đang xử lý": 30,
    "Chờ xác nhận": 15,
    "Đã hủy": 10,
  };

  final List<Color> colorsStatus = [
    Colors.green,
    Colors.orange,
    Colors.blue,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    final List<PieChartSectionData> sections = [];
    int i = 0;

    // Create each section for Pie Chart
    orderStatus.forEach((key, value) {
      sections.add(
        PieChartSectionData(
          value: value,
          color: colorsStatus[i % colorsStatus.length],
          title: '${value.toStringAsFixed(0)}%',
          radius: 55,
          titleStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

      i++;
    });

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
            height: 200,
            width: 200,
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

        // Annotate
        _buildAnnotate(),
      ],
    );
  }

  // Widget Annotate
  Widget _buildAnnotate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // Loop in orderStatus array
      children: orderStatus.entries.map((entry) {
        // Turn every key in orderStatus array into its index
        //  "Hoàn thành" : index 0
        int index = orderStatus.keys.toList().indexOf(entry.key);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              // Colors dot
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  // colorsStauts[0] => Hoành thành is green
                  color: colorsStatus[index],
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 8),

              // Annotate
              Flexible(
                child: Text(
                  "${entry.key} (${entry.value.toStringAsFixed(0)}%)",
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
