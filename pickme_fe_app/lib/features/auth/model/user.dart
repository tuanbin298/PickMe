class User {
  final String? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? role;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;
  final bool? isActive;
  final String? token;

  User({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.role,
    this.createdAt,
    this.lastLoginAt,
    this.isActive,
    this.token,
  });

  // Parse data from JSON into model
  factory User.fromJson(Map<String, dynamic> json) {
    final data = json['user'] ?? json;
    return User(
      id: data['id'],
      username: data['username'],
      email: data['email'],
      firstName: data['first_name'],
      lastName: data['last_name'],
      role: data['role'],
      token: json['token'], //token have only on login response
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : null,
      lastLoginAt: data['last_login_at'] != null
          ? DateTime.parse(data['last_login_at'])
          : null,
      isActive: data['is_active'],
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
    };
  }
}
