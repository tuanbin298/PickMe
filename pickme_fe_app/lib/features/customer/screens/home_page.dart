import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/customer/widgets/custom_location_app_bar.dart';
import 'package:pickme_fe_app/features/customer/widgets/category_horizontal_list.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Location App Bar
              CustomLocationAppBar(),

              SizedBox(height: 10),

              // Category Horizontal List
              CategoryHorizontalList(),
            ],
          ),
        ),
      ),
    );
  }
}
