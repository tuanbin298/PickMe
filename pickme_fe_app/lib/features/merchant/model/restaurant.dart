class Restaurant {
  final int? id;
  final String? name;
  final String? description;
  final String? address;
  final String? phoneNumber;
  final String? email;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final String? openingTime;
  final String? closingTime;
  final bool? isActive;
  final double? rating;
  final int? totalReviews;
  final int? ownerId;
  final String? ownerName;
  final String? approvalStatus;
  final int? approvedBy;
  final String? approvedByName;
  final DateTime? approvedAt;
  final String? rejectionReason;
  final List<String>? categories;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isOpen;
  final bool? isApproved;

  Restaurant({
    this.id,
    this.name,
    this.description,
    this.address,
    this.phoneNumber,
    this.email,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.openingTime,
    this.closingTime,
    this.isActive,
    this.rating,
    this.totalReviews,
    this.ownerId,
    this.ownerName,
    this.approvalStatus,
    this.approvedBy,
    this.approvedByName,
    this.approvedAt,
    this.rejectionReason,
    this.categories,
    this.createdAt,
    this.updatedAt,
    this.isOpen,
    this.isApproved,
  });

  // Parse data from JSON into model
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      imageUrl: json['imageUrl'],
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      openingTime: json['openingTime'],
      closingTime: json['closingTime'],
      isActive: json['isActive'],
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'],
      ownerId: json['ownerId'],
      ownerName: json['ownerName'],
      approvalStatus: json['approvalStatus'],
      approvedBy: json['approvedBy'],
      approvedByName: json['approvedByName'],
      approvedAt: json['approvedAt'] != null
          ? DateTime.tryParse(json['approvedAt'])
          : null,
      rejectionReason: json['rejectionReason'],
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      isOpen: json['isOpen'],
      isApproved: json['isApproved'],
    );
  }
}
