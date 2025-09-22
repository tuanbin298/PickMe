class User {
  final String userId;
  final String username;
  final String token;
  final DateTime expiresAt;

  User({
    required this.userId,
    required this.username,
    required this.token,
    required this.expiresAt,
  });

  // Parse data from JSON into model
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      token: json['token'] ?? '',
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }

  // Parse data from model into JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'token': token,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }
}
