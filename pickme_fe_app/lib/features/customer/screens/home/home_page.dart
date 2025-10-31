import 'package:flutter/material.dart';
import '../../widgets/home/custom_location_app_bar.dart';
import '../../widgets/home/public_restaurant_list.dart';

class Homepage extends StatefulWidget {
  final String token;

  const Homepage({super.key, required this.token});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Homepage header
            const CustomLocationAppBar(),

            const SizedBox(height: 10),

            // Homepage restaurant
            PublicRestaurantList(token: widget.token),
          ],
        ),
      ),
    );
  }
}
