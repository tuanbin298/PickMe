class Restaurant {
  final String id;
  final String name;
  final String imageUrl;
  final String address;
  final String phoneNumber;
  final String openingTime;
  final String closingTime;
  final double rating;
  final bool isOpen;
  final List<String> categories;

  Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.address,
    required this.phoneNumber,
    required this.openingTime,
    required this.closingTime,
    required this.rating,
    required this.isOpen,
    required this.categories,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      openingTime: json['openingTime'] ?? '',
      closingTime: json['closingTime'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      isOpen: json['isOpen'] ?? false,
      categories: List<String>.from(json['categories'] ?? []),
    );
  }
}
