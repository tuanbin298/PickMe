import 'package:pickme_fe_app/features/customer/models/customer/customer.dart';
import 'package:pickme_fe_app/features/customer/models/restaurant/restaurant.dart';

// Model Order
class Order {
  final int? id;
  final String? qrCode;
  final Customer? customer;
  final Restaurant? restaurant;
  final String? deliveryAddress;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final double? currentLatitude;
  final double? currentLongitude;
  final DateTime? preferredPickupTime;
  final double? discountAmount;
  final double? totalAmount;
  final String? status;
  final String? paymentStatus;
  final List<OrderItem>? orderItems;

  Order({
    this.id,
    this.qrCode,
    this.customer,
    this.restaurant,
    this.deliveryAddress,
    this.pickupLatitude,
    this.pickupLongitude,
    this.currentLatitude,
    this.currentLongitude,
    this.preferredPickupTime,
    this.discountAmount,
    this.totalAmount,
    this.status,
    this.paymentStatus,
    this.orderItems,
  });

  // Parse model into json
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      qrCode: json['qrCode'] ?? '',
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'])
          : null,
      restaurant: json['restaurant'] != null
          ? Restaurant.fromJson(json['restaurant'])
          : null,
      deliveryAddress: json['deliveryAddress'] ?? '',
      pickupLatitude: (json['pickupLatitude'] ?? 0).toDouble(),
      pickupLongitude: (json['pickupLongitude'] ?? 0).toDouble(),
      currentLatitude: (json['currentLatitude'] ?? 0).toDouble(),
      currentLongitude: (json['currentLongitude'] ?? 0).toDouble(),
      preferredPickupTime: json['preferredPickupTime'] != null
          ? DateTime.tryParse(json['preferredPickupTime'])
          : null,
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      paymentStatus: json['paymentStatus'] ?? '',
      status: json['status'] ?? '',
      orderItems: json['orderItems'] != null
          ? (json['orderItems'] as List)
                .map((item) => OrderItem.fromJson(item))
                .toList()
          : [],
    );
  }
}

// Model order item
class OrderItem {
  final int? id;
  final int? menuItemId;
  final String? menuItemName;
  final String? menuItemDescription;
  final String? menuItemCategory;
  final String? menuItemImageUrl;
  final int? quantity;
  final double? unitPrice;
  final double? subtotal;
  final double? totalPrice;
  final String? specialInstructions;
  final DateTime? createdAt;

  OrderItem({
    this.id,
    this.menuItemId,
    this.menuItemName,
    this.menuItemDescription,
    this.menuItemCategory,
    this.menuItemImageUrl,
    this.quantity,
    this.unitPrice,
    this.subtotal,
    this.totalPrice,
    this.specialInstructions,
    this.createdAt,
  });

  // Parse model into json
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      menuItemId: json['menuItemId'],
      menuItemName: json['menuItemName'] ?? '',
      menuItemDescription: json['menuItemDescription'] ?? '',
      menuItemCategory: json['menuItemCategory'] ?? '',
      menuItemImageUrl: json['menuItemImageUrl'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      specialInstructions: json['specialInstructions'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}
