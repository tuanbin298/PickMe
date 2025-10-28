import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/merchant/widgets/merchant_home/merchant_overview_section.dart';
import 'package:pickme_fe_app/features/merchant/widgets/merchant_home/build_welcome_banner.dart';
import 'package:pickme_fe_app/features/merchant/widgets/merchant_home_chart/merchant_order_chart.dart';
import 'package:pickme_fe_app/features/merchant/widgets/merchant_home_chart/merchant_revenue_chart.dart';

class MerchantHomePage extends StatefulWidget {
  final String token;

  const MerchantHomePage({super.key, required this.token});

  @override
  State<MerchantHomePage> createState() => _MerchantHomePageState();
}

class _MerchantHomePageState extends State<MerchantHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar
      appBar: AppBar(
        title: const Text(
          "Trang chủ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Buildwelcomebanner(),

            const SizedBox(height: 20),

            // Overview
            MerchantOverviewSection(token: widget.token),

            const SizedBox(height: 20),

            // Revenue chart
            MerchantRevenueChart(),

            const SizedBox(height: 20),

            // Order chart
            MerchantOrderChart(),
          ],
        ),
      ),
    );
  }
}
