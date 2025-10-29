import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant': restaurant.toJson(),
      'cartItems': cartItems.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'totalAmount': totalAmount,
      'totalItems': totalItems,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menuItemId': menuItemId,
      'menuItemName': menuItemName,
      'menuItemDescription': menuItemDescription,
      'menuItemCategory': menuItemCategory,
      'menuItemImageUrl': menuItemImageUrl,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'subtotal': subtotal,
      'totalPrice': totalPrice,
      'specialInstructions': specialInstructions,
      'addOns': addOns.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'isAvailable': isAvailable,
      'displayOrder': displayOrder,
      'maxQuantity': maxQuantity,
      'isRequired': isRequired,
    };
  }
}
