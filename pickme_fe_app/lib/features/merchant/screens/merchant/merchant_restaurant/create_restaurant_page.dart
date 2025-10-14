import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pickme_fe_app/core/common_services/upload_image_cloudinary.dart';
import 'package:pickme_fe_app/core/common_widgets/notification_service.dart';
import 'package:pickme_fe_app/core/theme/app_colors.dart';
import 'package:pickme_fe_app/features/merchant/services/restaurant/form_validator_service.dart';
import 'package:pickme_fe_app/features/merchant/services/restaurant/restaurant_services.dart';
import 'package:pickme_fe_app/features/merchant/widgets/address_picker_field.dart';
import 'package:pickme_fe_app/features/merchant/widgets/categories_picker_field.dart';
import 'package:pickme_fe_app/features/merchant/widgets/image_picker_field.dart';
import 'package:pickme_fe_app/features/merchant/widgets/information_form.dart';
import 'package:pickme_fe_app/features/merchant/widgets/location_picker_field.dart';
import 'package:pickme_fe_app/features/merchant/widgets/time_picker_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateRestaurantPage extends StatefulWidget {
  final String token;
  const CreateRestaurantPage({super.key, required this.token});

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
  List<String> _selectedCategories = [];
  bool isLoading = false;

  // Create instance object of UploadImageCloudinary
  final UploadImageCloudinary _uploadImageCloudinary = UploadImageCloudinary();

  // Create instance object of RestaurantServices
  final RestaurantServices restaurantServices = RestaurantServices();

  // Variable to store image, if dont have image = null
  File? _coverImage;

  // Variable for categories dropdown
  final List<String> _allCategories = [
    "Cafe",
    "Trà sữa",
    "Ăn vặt",
    "Cơm trưa",
    "Bánh ngọt",
    "Đồ ăn chay",
    "Đồ ăn sáng",
  ];

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

  void _onConfirmPressed() async {
    // Get token
    final token = widget.token;

    setState(() {
      isLoading = true;
    });

    // Check valid
    final isValid = FormValidatorService.validateRestaurantForm(
      context: context,
      coverImage: _coverImage,
      restaurantName: _restaurantName.text,
      description: _description.text,
      address: _address.text,
      openingTime: _openingTime,
      closingTime: _closingTime,
      latitude: _latitude,
      longitude: _longitude,
      selectedCategories: _selectedCategories,
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

    final restaurantData = {
      "name": _restaurantName.text,
      "description": _description.text,
      "address": _address.text,
      "phoneNumber": _phoneNumber.text,
      "email": _email.text,
      "imageUrl": imageUrl,
      "latitude": _latitude,
      "longitude": _longitude,
      "openingTime": "${_openingTime!.format(context)}:00",
      "closingTime": "${_closingTime!.format(context)}:00",
      "categories": _selectedCategories,
    };

    try {
      final newRestaurant = await restaurantServices.createRestaurantsByOwner(
        token,
        restaurantData,
      );

      if (!mounted) return;

      if (newRestaurant != null) {
        NotificationService.showSuccess(context, "Tạo cửa hàng thành công!");

        await Future.delayed(const Duration(seconds: 1));

        // Return true to reload restaurant list page
        if (mounted) Navigator.pop(context, true);
      } else {
        NotificationService.showSuccess(context, "Tạo cửa hàng thất bại!");
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

            // Card information form - restaurant
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

                    // Information form - restaurant address
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.map),
                        label: const Text("Chọn địa chỉ"),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddressPickerField(),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              _address.text = result['address'];
                              _latitude = result['latitude'];
                              _longitude = result['longitude'];
                            });
                          }
                        },
                      ),
                    ),

                    InformationForm(
                      label: "Địa chỉ",
                      icon: Icons.location_on,
                      color: Colors.redAccent,
                      controller: _address,
                      readOnly: true,
                    ),

                    const SizedBox(height: 16),

                    // Location
                    LocationPickerField(
                      latitude: _latitude,
                      longitude: _longitude,
                      // onLocationSelected: (object) {
                      //   setState(() {
                      //     _latitude = object["latitude"];
                      //     _longitude = object["longitude"];
                      //   });
                      // },
                    ),

                    const SizedBox(height: 16),

                    // Categories
                    CategoriesPickerField(
                      allCategories: _allCategories,
                      selectedCategories: _selectedCategories,
                      onCategoriesSelected: (cate) {
                        setState(() {
                          _selectedCategories = cate;
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
                  isLoading ? "Đang đăng ký" : "Đăng ký",
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
