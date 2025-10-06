import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateRestaurantIntro extends StatefulWidget {
  const CreateRestaurantIntro({super.key});

  @override
  State<CreateRestaurantIntro> createState() => _CreateRestaurantIntroState();
}

class _CreateRestaurantIntroState extends State<CreateRestaurantIntro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Center(
                  child: Image.asset(
                    'lib/assets/images/pickme_logo.png',
                    width: 250,
                  ),
                ),

                const SizedBox(height: 40),

                // Card intro
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Hoàn tất hồ sơ của bạn!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Hãy tạo quán ăn của riêng bạn và bắt đầu bán ngay hôm nay!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),

                        const SizedBox(height: 20),

                        // Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffFC7A1F),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            context.push("/merchant-create-resaurant");
                          },
                          child: const Text(
                            "Tạo quán ăn",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
