class NotificationPrefModel {
  final bool general;
  final bool offers;

  NotificationPrefModel({required this.general, required this.offers});

  factory NotificationPrefModel.fromJson(Map<String, dynamic> json) => NotificationPrefModel(
        general: json['general'] == true,
        offers: json['offers'] == true,
      );

  Map<String, dynamic> toJson() => {
        'general': general,
        'offers': offers,
      };
}
