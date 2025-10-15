class AccountModel {
  final int id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? imageUrl;
  final String? role;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AccountModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.imageUrl,
    this.role,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] is int
        ? json['id']
        : int.tryParse(json['id'].toString()) ?? 0;
    final fullName = json['fullName'] ?? json['full_name'] ?? '';
    final email = json['email'] ?? '';
    final phone = json['phoneNumber'] ?? json['phone'] ?? json['phone_number'];
    final image =
        json['imageUrl'] ??
        json['image_url'] ??
        json['avatar'] ??
        json['avatarUrl'];
    final role = json['role']?.toString();
    final isActive = _parseBool(json['isActive'] ?? json['is_active']);

    DateTime? createdAt;
    DateTime? updatedAt;
    try {
      if (json['createdAt'] != null)
        createdAt = DateTime.parse(json['createdAt']);
      if (json['created_at'] != null)
        createdAt = DateTime.parse(json['created_at']);
      if (json['updatedAt'] != null)
        updatedAt = DateTime.parse(json['updatedAt']);
      if (json['updated_at'] != null)
        updatedAt = DateTime.parse(json['updated_at']);
    } catch (_) {
      // ignore parse errors
    }

    return AccountModel(
      id: id,
      fullName: fullName,
      email: email,
      phoneNumber: phone?.toString(),
      imageUrl: image?.toString(),
      role: role,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'fullName': fullName,
    if (phoneNumber != null) 'phoneNumber': phoneNumber,
    if (imageUrl != null) 'imageUrl': imageUrl,
    if (role != null) 'role': role,
    if (isActive != null) 'isActive': isActive,
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
  };

  AccountModel copyWith({
    int? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? imageUrl,
    String? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static bool? _parseBool(dynamic v) {
    if (v == null) return null;
    if (v is bool) return v;
    if (v is num) return v != 0;
    final s = v.toString().toLowerCase();
    if (s == 'true' || s == '1' || s == 'yes' || s == 'y') return true;
    if (s == 'false' || s == '0' || s == 'no' || s == 'n') return false;
    return null;
  }
}
