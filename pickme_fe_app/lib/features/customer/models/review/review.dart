class Review {
  final int? id;
  final int orderId;
  final int? restaurantId;
  final int? menuItemId;
  final int overallRating;
  final String comment;
  final List<String> imageUrls;
  final DateTime? createdAt;
  final String? reviewerName;
  final String? reviewType;
  final String? ownerResponse;

  Review({
    this.id,
    required this.orderId,
    this.restaurantId,
    this.menuItemId,
    required this.overallRating,
    required this.comment,
    this.imageUrls = const [],
    this.createdAt,
    this.reviewerName,
    this.reviewType,
    this.ownerResponse,
  });

  /// Parse JSON -> Review
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      orderId: json['orderId'] is int
          ? json['orderId']
          : int.tryParse('${json['orderId']}') ?? 0,
      restaurantId: json['restaurantId'] is int
          ? json['restaurantId']
          : int.tryParse('${json['restaurantId']}'),
      menuItemId: json['menuItemId'] is int
          ? json['menuItemId']
          : int.tryParse('${json['menuItemId']}'),
      overallRating:
          json['overallRating'] ??
          json['rating'] ??
          0, // có API trả rating, có API trả overallRating
      comment: json['comment'] ?? '',
      imageUrls:
          (json['imageUrls'] as List?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      reviewerName: json['reviewerName'],
      reviewType: json['reviewType'],
      ownerResponse: json['ownerResponse'],
    );
  }

  Review copyWith({
    int? id,
    int? orderId,
    int? restaurantId,
    int? menuItemId,
    int? overallRating,
    String? comment,
    List<String>? imageUrls,
    DateTime? createdAt,
    String? reviewerName,
    String? reviewType,
    String? ownerResponse,
  }) {
    return Review(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      restaurantId: restaurantId ?? this.restaurantId,
      menuItemId: menuItemId ?? this.menuItemId,
      overallRating: overallRating ?? this.overallRating,
      comment: comment ?? this.comment,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      reviewerName: reviewerName ?? this.reviewerName,
      reviewType: reviewType ?? this.reviewType,
      ownerResponse: ownerResponse ?? this.ownerResponse,
    );
  }

  @override
  String toString() {
    return 'Review(id: $id, orderId: $orderId, rating: $overallRating, comment: $comment, reviewer: $reviewerName)';
  }
}
