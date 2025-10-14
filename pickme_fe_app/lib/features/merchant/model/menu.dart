class FoodItem {
  final int? id;
  final String? name;
  final String? description;
  final double? price;
  final String? imageUrl;
  final String? category;
  final bool? isAvailable;
  final int? preparationTime;
  final String? ingredients;
  final String? restaurantName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FoodItem({
    this.id,
    this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.category,
    this.isAvailable,
    this.preparationTime,
    this.ingredients,
    this.restaurantName,
    this.createdAt,
    this.updatedAt,
  });
}
