import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/merchant/widgets/image_picker_field.dart';
import 'package:pickme_fe_app/features/merchant/widgets/information_form.dart';
import 'package:pickme_fe_app/features/merchant/widgets/location_picker_field.dart';
import 'package:pickme_fe_app/features/merchant/widgets/time_picker_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class CreateRestaurantPage extends StatefulWidget {
  const CreateRestaurantPage({super.key});

  @override
  State<CreateRestaurantPage> createState() => _CreateRestaurantPageState();
}

class _CreateRestaurantPageState extends State<CreateRestaurantPage> {
  final _fullName = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _email = TextEditingController();
  final _restaurantName = TextEditingController();
  final _description = TextEditingController();
  final _address = TextEditingController();
  TimeOfDay? _openingTime;
  TimeOfDay? _closingTime;
  double? _latitude;
  double? _longitude;

  // Variable to store image, if dont have image = null
  File? _coverImage;

  @override
  void initState() {
    super.initState();
    _loadDataFromPrefs();
  }

  // Set data for SharedPreferences variables
  Future<void> _loadDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _fullName.text = prefs.getString("fullName") ?? "";
      _phoneNumber.text = prefs.getString("phoneNumber") ?? "";
      _email.text = prefs.getString("email") ?? "";
    });
  }

  void _onConfirmPressed() {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Thêm thông tin cửa hàng",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),

      // Content
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Get photo from gallery
            ImagePickerField(
              height: 200,
              onImageSelected: (file) {
                setState(() {
                  _coverImage = file;
                });
              },
            ),

            const SizedBox(height: 20),

            // Card information form - owner
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "Thông tin cơ bản",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Information form - fullName
                    InformationForm(
                      label: "Tên chủ quán",
                      icon: Icons.person,
                      color: Colors.teal,
                      controller: _fullName,
                      readOnly: true,
                    ),

                    const SizedBox(height: 16),

                    // Information form - phoneNumber
                    InformationForm(
                      label: "Số điện thoại",
                      icon: Icons.phone,
                      color: Colors.green,
                      controller: _phoneNumber,
                      readOnly: true,
                    ),

                    const SizedBox(height: 16),

                    // Information form - email
                    InformationForm(
                      label: "Mail",
                      icon: Icons.email,
                      color: Colors.deepOrange,
                      controller: _email,
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Card ìnormation form - restaurant
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "Thông tin cửa hàng",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Information form - restaurant name
                    InformationForm(
                      label: "Tên cửa hàng",
                      icon: Icons.store,
                      color: Colors.orange,
                      controller: _restaurantName,
                      readOnly: false,
                    ),

                    const SizedBox(height: 16),

                    // Information form - restaurant description
                    InformationForm(
                      label: "Mô tả",
                      icon: Icons.description,
                      color: Colors.indigo,
                      controller: _description,
                      readOnly: false,
                    ),

                    const SizedBox(height: 16),

                    // Information form - restaurant address
                    InformationForm(
                      label: "Địa chỉ",
                      icon: Icons.location_on,
                      color: Colors.redAccent,
                      controller: _address,
                      readOnly: false,
                    ),

                    const SizedBox(height: 16),

                    // Time picker - Open time - close time
                    TimePickerField(
                      label: "Giờ mở cửa",
                      icon: Icons.lock_open,
                      color: Colors.green,
                      initialTime: _openingTime,
                      readOnly: false,
                      onTimeSelected: (time) {
                        setState(() {
                          _openingTime = time;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    TimePickerField(
                      label: "Giờ đóng cửa",
                      icon: Icons.lock_clock,
                      color: Colors.deepOrange,
                      initialTime: _closingTime,
                      readOnly: false,
                      onTimeSelected: (time) {
                        setState(() {
                          _closingTime = time;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Location
                    LocationPickerField(
                      latitude: _latitude,
                      longitude: _longitude,
                      onLocationSelected: (object) {
                        setState(() {
                          _latitude = object["latitude"];
                          _longitude = object["longitude"];
                        });
                      },
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Button "xác nhận"
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _onConfirmPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Xác nhận",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
