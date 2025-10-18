class User {
  final int? id;
  final String? email;
  final String? fullName;
  final String? phoneNumber;
  final String? imageUrl;
  final String? role;
  final DateTime? createdAt;
  final String? token;
  final String? type;

  User({
    this.id,
    this.email,
    this.fullName,
    this.phoneNumber,
    this.imageUrl,
    this.role,
    this.createdAt,
    this.token,
    this.type,
  });

  // Parse data from JSON into model
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      imageUrl: json['imageUrl'],
      role: json['role'],
      token: json['token'],
      type: json['type'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }
}
