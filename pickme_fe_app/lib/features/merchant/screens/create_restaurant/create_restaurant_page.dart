import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/merchant/widgets/image_picker_field.dart';
import 'package:pickme_fe_app/features/merchant/widgets/information_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateRestaurantPage extends StatefulWidget {
  const CreateRestaurantPage({super.key});

  @override
  State<CreateRestaurantPage> createState() => _CreateRestaurantPageState();
}

class _CreateRestaurantPageState extends State<CreateRestaurantPage> {
  final _fullName = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _email = TextEditingController();

  // Variable to store image, if dont have image = null
  File? _coverImage;

  // Controller to get data from inputs
  final _formKey = GlobalKey<FormState>();

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
              height: 500,
              onImageSelected: (file) {
                setState(() {
                  _coverImage = file;
                });
              },
            ),

            const SizedBox(height: 20),

            // Card information form
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
                      controller: _fullName,
                      readOnly: true,
                    ),

                    const SizedBox(height: 16),

                    // Information form - phoneNumber
                    InformationForm(
                      label: "Số điện thoại",
                      icon: Icons.phone,
                      controller: _phoneNumber,
                      readOnly: true,
                    ),

                    const SizedBox(height: 16),

                    // Information form - email
                    InformationForm(
                      label: "Mail",
                      icon: Icons.email,
                      controller: _email,
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
