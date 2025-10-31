class Payment {
  int? id;
  int? orderId;
  String? orderQrCode;
  double? amount;
  String? paymentMethod;
  String? paymentMethodDisplayName;
  String? paymentStatus;
  String? paymentStatusDisplayName;
  String? transactionId;
  String? qrCodeUrl;
  String? failureReason;
  String? paidAt;
  String? createdAt;
  String? updatedAt;

  Payment({
    this.id,
    this.orderId,
    this.orderQrCode,
    this.amount,
    this.paymentMethod,
    this.paymentMethodDisplayName,
    this.paymentStatus,
    this.paymentStatusDisplayName,
    this.transactionId,
    this.qrCodeUrl,
    this.failureReason,
    this.paidAt,
    this.createdAt,
    this.updatedAt,
  });

  // Parse data from json
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      orderId: json['orderId'],
      orderQrCode: json['orderQrCode'],
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : json['amount']?.toDouble(),
      paymentMethod: json['paymentMethod'],
      paymentMethodDisplayName: json['paymentMethodDisplayName'],
      paymentStatus: json['paymentStatus'],
      paymentStatusDisplayName: json['paymentStatusDisplayName'],
      transactionId: json['transactionId'],
      qrCodeUrl: json['qrCodeUrl'],
      failureReason: json['failureReason'],
      paidAt: json['paidAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
