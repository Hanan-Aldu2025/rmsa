class DeliveryOption {
  final String id;
  final String name;
  final String type;
  final String estimatedTime;
  final double extraPrice;
  final bool isActive;

  DeliveryOption({
    required this.id,
    required this.name,
    required this.type,
    required this.estimatedTime,
    required this.extraPrice,
    required this.isActive,
  });

  factory DeliveryOption.fromFirestore(
    Map<String, dynamic> json,
    String docId,
  ) {
    return DeliveryOption(
      id: docId,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      estimatedTime: json['estimated_time'] ?? '',
      extraPrice:
          double.tryParse(json['extra_price']?.toString() ?? '0') ?? 0.0,
      isActive: json['isActive'] ?? true,
    );
  }
}
