import 'package:flutter/material.dart';

class Restaurant {
  final String? name;
  final String? description;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? phoneNumber;
  final String? imageUrl;
  final TimeOfDay? openingTime;
  final TimeOfDay? closingTime;
  final List<String>? categories;

  Restaurant({
    this.name,
    this.description,
    this.address,
    this.latitude,
    this.longitude,
    this.phoneNumber,
    this.imageUrl,
    this.openingTime,
    this.closingTime,
    this.categories,
  });

  // Parse data from JSON into model
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
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
