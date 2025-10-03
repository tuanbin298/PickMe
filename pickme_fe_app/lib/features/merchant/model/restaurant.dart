import 'package:flutter/material.dart';
import 'package:pickme_fe_app/features/merchant/model/food_item.dart';

class Restaurant {
  final int? id;
  final String? name;
  final String? description;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? phoneNumber;
  final String? imageUrl;
  final TimeOfDay? openingTime;
  final TimeOfDay? closingTime;
  final bool? isActive;
  final double? averageRating;
  final int? totalReviews;
  final String? ownerName;
  final List<FoodItem>? foodItems;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Restaurant({
    this.id,
    this.name,
    this.description,
    this.address,
    this.latitude,
    this.longitude,
    this.phoneNumber,
    this.imageUrl,
    this.openingTime,
    this.closingTime,
    this.isActive,
    this.averageRating,
    this.totalReviews,
    this.ownerName,
    this.foodItems,
    this.createdAt,
    this.updatedAt,
  });

  // Parse data from JSON into model
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      phoneNumber: json['phoneNumber'],
      imageUrl: json['imageUrl'],
    );
  }
}
