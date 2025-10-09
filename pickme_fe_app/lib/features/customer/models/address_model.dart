class AddressModel {
  final String id;
  final String label;
  final String addressLine;

  AddressModel({required this.id, required this.label, required this.addressLine});

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json['id']?.toString() ?? '',
        label: json['label'] ?? '',
        addressLine: json['addressLine'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'addressLine': addressLine,
      };
}
