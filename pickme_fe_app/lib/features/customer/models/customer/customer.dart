class Customer {
  final int id;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String? imageUrl;
  final String? role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Customer({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    this.imageUrl,
    this.role,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  // Parse data from JSON into model
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      imageUrl: json['imageUrl'],
      role: json['role'],
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}
