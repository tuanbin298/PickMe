class RestaurantMenu {
  final int id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final bool isAvailable;
  final int preparationTimeMinutes;
  final List<String> tags;

  RestaurantMenu({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.isAvailable,
    required this.preparationTimeMinutes,
    required this.tags,
  });

  /// Factory constructor to parse from JSON
  factory RestaurantMenu.fromJson(Map<String, dynamic> json) {
    return RestaurantMenu(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
      preparationTimeMinutes: json['preparationTimeMinutes'] ?? 0,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : <String>[],
    );
  }
}
