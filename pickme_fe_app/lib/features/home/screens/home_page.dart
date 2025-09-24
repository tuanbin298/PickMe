import 'package:flutter/material.dart';
import 'package:pickme_fe_app/features/home/widgets/custom_location_app_bar.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              CustomLocationAppBar(),
              // Sau này thêm CategoryHorizontalList, RestaurantListWidget...
            ],
          ),
        ),
      ),
    );
  }
}
