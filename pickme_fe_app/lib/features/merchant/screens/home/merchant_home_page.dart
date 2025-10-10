import 'package:flutter/material.dart';
import 'package:pickme_fe_app/features/merchant/screens/profile/merchant_profile.dart';
import 'package:pickme_fe_app/features/merchant/screens/restaurant_list/restaurant_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MerchantHomePage extends StatefulWidget {
  const MerchantHomePage({super.key});

  @override
  State<MerchantHomePage> createState() => _MerchantHomePageState();
}

class _MerchantHomePageState extends State<MerchantHomePage> {
  int _selectedIndex = 0;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  // Method get token
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');
    setState(() {
      _token = savedToken;
    });
  }

  // Switching between screen
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Waiting until _token have value then render UI
    if (_token == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Screen list
    final List<Widget> _screens = [
      //Restaurant screen
      RestaurantListPage(token: _token!),

      //Profile screen
      MerchantProfile(token: _token!),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _screens[_selectedIndex],
        // BottomNavigationBar
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          items: const [
            // List restaurant
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              activeIcon: Icon(Icons.list),
              label: 'Danh sách cửa hàng',
            ),

            // Profile
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Cá nhân',
            ),
          ],
        ),
      ),
    );
  }
}
