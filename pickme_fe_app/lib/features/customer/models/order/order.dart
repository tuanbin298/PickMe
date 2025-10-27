class OrderModel {
  final String title;
  final String address;
  final double price;
  final int quantity;
  final String status;
  final String date;
  final String image;

  OrderModel({
    required this.title,
    required this.address,
    required this.price,
    required this.quantity,
    required this.status,
    required this.date,
    required this.image,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      title: json['title'] ?? '',
      address: json['address'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      status: json['status'] ?? '',
      date: json['date'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
