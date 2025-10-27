class Restaurant {
  final int id;
  final String name;
  final String imageUrl;
  final String address;
  final String? description;
  final String phoneNumber;
  final String openingTime;
  final String closingTime;
  final double? latitude;
  final double? longitude;
  final double rating;
  final bool isOpen;
  final List<String> categories;
  final bool? isApproved;

  Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.address,
    this.description,
    this.latitude,
    this.longitude,
    required this.phoneNumber,
    required this.openingTime,
    required this.closingTime,
    required this.rating,
    required this.isOpen,
    required this.categories,
    this.isApproved,
  });

  // Parse data from JSON into model
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: (json['id'] ?? 0).toInt(),
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      address: json['address'] ?? '',
      description: json['description'],
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      phoneNumber: json['phoneNumber'] ?? '',
      openingTime: json['openingTime'] ?? '',
      closingTime: json['closingTime'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      isOpen: json['isOpen'] ?? false,
      categories: List<String>.from(json['categories'] ?? []),
      isApproved: json['isApproved'],
    );
  }
}
