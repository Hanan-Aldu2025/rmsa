class DeliveryMethodModel {
  final String id;
  final String name;
  final double price;

  DeliveryMethodModel({required this.id, required this.name, required this.price});

  factory DeliveryMethodModel.fromMap(Map<String, dynamic> map) {
    return DeliveryMethodModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
    );
  }
}