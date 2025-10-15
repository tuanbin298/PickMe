class PaymentMethodModel {
  final String id;
  final String brand;
  final String last4;
  final String exp;

  PaymentMethodModel({required this.id, required this.brand, required this.last4, required this.exp});

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) => PaymentMethodModel(
        id: json['id']?.toString() ?? '',
        brand: json['brand'] ?? '',
        last4: json['last4'] ?? '',
        exp: json['exp'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'brand': brand,
        'last4': last4,
        'exp': exp,
      };
}
