import 'dart:io';
import 'package:flutter/material.dart';

class FormValidatorService {
  // Validate restaurant form
  static bool validateRestaurantForm({
    required BuildContext context,
    required File? coverImage,
    required String restaurantName,
    required String description,
    required String address,
    required TimeOfDay? openingTime,
    required TimeOfDay? closingTime,
    required double? latitude,
    required double? longitude,
    required List<String> selectedCategories,
  }) {
    if (coverImage == null) {
      _showError(context, "Vui lòng chọn ảnh bìa cửa hàng");
      return false;
    }

    if (restaurantName.trim().isEmpty) {
      _showError(context, "Vui lòng nhập tên cửa hàng");
      return false;
    }

    if (description.trim().isEmpty) {
      _showError(context, "Vui lòng nhập mô tả cửa hàng");
      return false;
    }

    if (address.trim().isEmpty) {
      _showError(context, "Vui lòng nhập địa chỉ cửa hàng");
      return false;
    }

    if (openingTime == null) {
      _showError(context, "Vui lòng nhập thời gian mở cửa quán");
      return false;
    }

    if (closingTime == null) {
      _showError(context, "Vui lòng nhập thời gian đóng cửa quán");
      return false;
    }

    if (latitude == null || longitude == null) {
      _showError(context, "Vui lòng chọn vị trí cửa hàng trên bản đồ");
      return false;
    }

    if (selectedCategories.isEmpty) {
      _showError(context, "Vui lòng chọn ít nhất một danh mục món");
      return false;
    }

    return true;
  }

  // Validate menu form
  static bool validMenuForm({
    required BuildContext context,
    required String name,
    required File? coverImage,
    required String description,
    required String category,
    required String price,
    required String preparationTime,
    required List<String> selectedTags,
  }) {
    if (coverImage == null) {
      _showError(context, "Vui lòng chọn ảnh món ăn");
      return false;
    }

    if (name.trim().isEmpty) {
      _showError(context, "Vui lòng nhập tên món ăn");
      return false;
    }

    if (description.trim().isEmpty) {
      _showError(context, "Vui lòng nhập mô tả món ăn");
      return false;
    }

    if (category.trim().isEmpty) {
      _showError(context, "Vui lòng nhập loại món ăn");
      return false;
    }

    if (price.trim().isEmpty) {
      _showError(context, "Vui lòng nhập giá món ăn");
      return false;
    }

    final double? parsedPrice = double.tryParse(price);
    if (parsedPrice == null || parsedPrice <= 0) {
      _showError(context, "Giá món ăn phải là số lớn hơn 0");
      return false;
    }

    if (preparationTime.trim().isEmpty) {
      _showError(context, "Vui lòng nhập thời gian chuẩn bị");
      return false;
    }

    final int? parsedPreparationTime = int.tryParse(preparationTime);
    if (parsedPreparationTime == null || parsedPreparationTime <= 0) {
      _showError(context, "Thời gian chuẩn bị phải là số nguyên lớn hơn 0");
      return false;
    }

    if (selectedTags.isEmpty) {
      _showError(context, "Vui lòng chọn ít nhất một tag");
      return false;
    }

    return true;
  }

  // Show error
  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }
}
