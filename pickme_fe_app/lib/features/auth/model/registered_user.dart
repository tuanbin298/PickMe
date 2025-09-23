// class RegisteredUser {
//   final String id;
//   final String username;
//   final String email;
//   final String firstName;
//   final String lastName;
//   final String role;
//   final String? createdAt;
//   final String? lastLoginAt;
//   final bool isActive;

//   RegisteredUser({
//     required this.id,
//     required this.username,
//     required this.email,
//     required this.firstName,
//     required this.lastName,
//     required this.role,
//     this.createdAt,
//     this.lastLoginAt,
//     required this.isActive,
//   });

//   factory RegisteredUser.fromJson(Map<String, dynamic> json) {
//     return RegisteredUser(
//       id: json['id'] ?? '',
//       username: json['username'] ?? '',
//       email: json['email'] ?? '',
//       firstName: json['firstName'] ?? '',
//       lastName: json['lastName'] ?? '',
//       role: json['role'] ?? '',
//       createdAt: json['createdAt'],
//       lastLoginAt: json['lastLoginAt'],
//       isActive: json['isActive'] ?? false,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'username': username,
//       'email': email,
//       'firstName': firstName,
//       'lastName': lastName,
//       'role': role,
//       'createdAt': createdAt,
//       'lastLoginAt': lastLoginAt,
//       'isActive': isActive,
//     };
//   }
// }
