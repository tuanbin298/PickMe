import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant.dart';

// Cart model
class Cart {
  final int id;
  final Restaurant restaurant;
  final List<CartItem> cartItems;
  final double subtotal;
  final double totalAmount;
  final int totalItems;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Cart({
    required this.id,
    required this.restaurant,
    required this.cartItems,
    required this.subtotal,
    required this.totalAmount,
    required this.totalItems,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Parse data from JSON into model
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: (json['id'] ?? 0).toInt(),
      restaurant: Restaurant.fromJson(json['restaurant'] ?? {}),
      cartItems: (json['cartItems'] as List<dynamic>? ?? [])
          .map((e) => CartItem.fromJson(e))
          .toList(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      totalItems: (json['totalItems'] ?? 0).toInt(),
      status: json['status'] ?? 'ACTIVE',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

// Cart item model
class CartItem {
  final int id;
  final int menuItemId;
  final String menuItemName;
  final String menuItemDescription;
  final String menuItemCategory;
  final String menuItemImageUrl;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final double totalPrice;
  final String? specialInstructions;
  final List<AddOn> addOns;
  final DateTime createdAt;

  CartItem({
    required this.id,
    required this.menuItemId,
    required this.menuItemName,
    required this.menuItemDescription,
    required this.menuItemCategory,
    required this.menuItemImageUrl,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    required this.totalPrice,
    this.specialInstructions,
    required this.addOns,
    required this.createdAt,
  });

  // Parse data from JSON into model
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: (json['id'] ?? 0).toInt(),
      menuItemId: (json['menuItemId'] ?? 0).toInt(),
      menuItemName: json['menuItemName'] ?? '',
      menuItemDescription: json['menuItemDescription'] ?? '',
      menuItemCategory: json['menuItemCategory'] ?? '',
      menuItemImageUrl: json['menuItemImageUrl'] ?? '',
      quantity: (json['quantity'] ?? 0).toInt(),
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      specialInstructions: json['specialInstructions'],
      addOns: (json['addOns'] as List<dynamic>? ?? [])
          .map((e) => AddOn.fromJson(e))
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

// Model add topping
class AddOn {
  final int id;
  final String name;
  final String description;
  final double price;
  final String category;
  final bool isAvailable;
  final int displayOrder;
  final int? maxQuantity;
  final bool isRequired;

  AddOn({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.isAvailable,
    required this.displayOrder,
    this.maxQuantity,
    required this.isRequired,
  });

  // Parse data from JSON into model
  factory AddOn.fromJson(Map<String, dynamic> json) {
    return AddOn(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
      displayOrder: json['displayOrder'] ?? 0,
      maxQuantity: json['maxQuantity'],
      isRequired: json['isRequired'] ?? false,
    );
  }
}
