class Menu {
  final int? id;
  final int? restaurantId;
  final String? restaurantName;
  final String? name;
  final String? description;
  final double? price;
  final String? category;
  final String? imageUrl;
  final bool? isAvailable;
  final int? preparationTimeMinutes;
  final List<String>? tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Menu({
    this.id,
    this.restaurantId,
    this.restaurantName,
    this.name,
    this.description,
    this.price,
    this.category,
    this.imageUrl,
    this.isAvailable,
    this.preparationTimeMinutes,
    this.tags,
    this.createdAt,
    this.updatedAt,
  });

  // Parse data from JSON into model
  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'] ?? 0,
      restaurantId: json['restaurantId'] ?? 0,
      restaurantName: json['restaurantName'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
      preparationTimeMinutes: json['preparationTimeMinutes'] ?? 0,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : <String>[],
      createdAt: json['createdAt'] != null && json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null && json['updatedAt'] is String
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'preparationTimeMinutes': preparationTimeMinutes,
      'tags': tags,
    };
  }
}
