import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد GeoPoint

/// يمثل عنصر واحد داخل السلة - الطبقة Domain
class CartItemEntity {
  final String id; // ← تمت إضافتها
  final ProductEntity product;
  final int quantity;
  final Map<String, dynamic>? selectedOptions;

  // إضافة إحداثيات المستخدم كـ GeoPoint
  final GeoPoint userLocation;

  const CartItemEntity({
    required this.id, // ← تمت إضافتها
    required this.product,
    this.quantity = 1,
    this.selectedOptions,
    required this.userLocation,   // تغيير إحداثيات المستخدم إلى GeoPoint
  });

  double get totalPrice {
    double price = product.price;

    // مثال: تعديل السعر بناءً على الحجم أو خيارات المستخدم
    if (selectedOptions != null) {
      final size = selectedOptions?['size'];
      if (size == 'Regular') price += 1.0;
      if (size == 'Large') price += 2.0;
    }

    return price * quantity;
  }

  CartItemEntity copyWith({
    String? id, // ← تمت إضافتها
    int? quantity,
    Map<String, dynamic>? selectedOptions,
    GeoPoint? userLocation,  // استبدال userLat و userLng بـ GeoPoint
  }) {
    return CartItemEntity(
      id: id ?? this.id, // ← تمت إضافتها
      product: product,
      quantity: quantity ?? this.quantity,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      userLocation: userLocation ?? this.userLocation,  // تغيير إحداثيات المستخدم إلى GeoPoint
    );
  }
}