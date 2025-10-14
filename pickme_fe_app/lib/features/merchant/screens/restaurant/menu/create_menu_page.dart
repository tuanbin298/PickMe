import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/common_widgets/notification_service.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/core/common_services/upload_image_cloudinary.dart';
import 'package:pickme_fe_app/features/merchant/services/menu/menu_services.dart';
import 'package:pickme_fe_app/features/merchant/services/restaurant/form_validator_service.dart';
import 'package:pickme_fe_app/features/merchant/widgets/categories_picker_field.dart';
import 'package:pickme_fe_app/features/merchant/widgets/image_picker_field.dart';
import 'package:pickme_fe_app/features/merchant/widgets/information_form.dart';

class CreateMenuPage extends StatefulWidget {
  final String restaurantId;
  final String token;

  const CreateMenuPage({
    super.key,
    required this.restaurantId,
    required this.token,
  });

  @override
  State<CreateMenuPage> createState() => _CreateMenuPageState();
}

class _CreateMenuPageState extends State<CreateMenuPage> {
  final _foodName = TextEditingController();
  final _description = TextEditingController();
  final _category = TextEditingController();
  final _price = TextEditingController();
  final _preparationTime = TextEditingController();
  List<String> _selectedTags = [];
  bool isLoading = false;

  // Create instance object of MenuServices
  final MenuServices menuServices = MenuServices();

  // Create instance object of UploadImageCloudinary
  final UploadImageCloudinary _uploadImageCloudinary = UploadImageCloudinary();
  // Variable to store image, if dont have image = null
  File? _coverImage;

  // Variable for tag dropdown
  final List<String> _allTags = ["Món cay", "Món chay", "Đồ ngọt"];

  // Method create and validate menu
  void _onConfirmPressed() async {
    setState(() {
      isLoading = true;
    });

    final isValid = FormValidatorService.validMenuForm(
      context: context,
      name: _foodName.text,
      coverImage: _coverImage,
      description: _description.text,
      category: _category.text,
      price: _price.text,
      preparationTime: _preparationTime.text,
      selectedTags: _selectedTags,
    );
    if (!isValid) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Upload image into cloudinary
    String? imageUrl;
    if (_coverImage != null) {
      imageUrl = await _uploadImageCloudinary.uploadImage(_coverImage!);
    }

    final menuData = {
      "name": _foodName.text,
      "description": _description.text,
      "price": double.parse(_price.text),
      "category": _category.text,
      "imageUrl": imageUrl,
      "isAvailable": true,
      "preparationTimeMinutes": int.parse(_preparationTime.text),
      "tags": _selectedTags,
    };

    try {
      final newMenu = await menuServices.createMenu(
        widget.token,
        widget.restaurantId,
        menuData,
      );

      if (!mounted) return;

      if (newMenu != null) {
        NotificationService.showSuccess(context, "Tạo món ăn thành công!");

        await Future.delayed(const Duration(seconds: 1));

        // Return true to reload menu list page
        if (mounted) Navigator.pop(context, true);
      } else {
        NotificationService.showSuccess(context, "Tạo món ăn thất bại!");
      }
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst("Exception: ", "");
      NotificationService.showError(context, message);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
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
          "Tạo món ăn",
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

            // Menu informattion form - menu
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
                      "Thông tin món ăn",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Information form - food name
                    InformationForm(
                      label: "Tên món ăn",
                      icon: Icons.fastfood,
                      color: Colors.orange,
                      controller: _foodName,
                      readOnly: false,
                    ),

                    const SizedBox(height: 16),

                    // Information form - food description
                    InformationForm(
                      label: "Mô tả",
                      icon: Icons.description,
                      color: Colors.indigo,
                      controller: _description,
                      readOnly: false,
                    ),

                    const SizedBox(height: 16),

                    // Information form - food category
                    InformationForm(
                      label: "Loại",
                      icon: Icons.category,
                      color: Colors.indigo,
                      controller: _category,
                      readOnly: false,
                    ),

                    const SizedBox(height: 16),

                    // Information form - food price
                    InformationForm(
                      label: "Giá",
                      icon: Icons.attach_money,
                      color: Colors.green,
                      controller: _price,
                      readOnly: false,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 16),

                    // Information form - food preparation time
                    InformationForm(
                      label: "Thời gian chuẩn bị món",
                      icon: Icons.timer,
                      color: Colors.deepOrange,
                      controller: _preparationTime,
                      keyboardType: TextInputType.number,
                      readOnly: false,
                    ),

                    const SizedBox(height: 16),

                    // Tag
                    CategoriesPickerField(
                      label: "Loại món ăn",
                      allCategories: _allTags,
                      selectedCategories: _selectedTags,
                      onCategoriesSelected: (cate) {
                        setState(() {
                          _selectedTags = cate;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Button "Đăng ký"
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _onConfirmPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isLoading ? "Đang tạo món" : "Tạo món",
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
