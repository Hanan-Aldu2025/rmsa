import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد GeoPoint
import 'package:appp/featurees/checkout_screens/cart_screen/domain/entity/cart_item_entity.dart';

/// Model مسؤول عن تحويل البيانات من/إلى JSON أو Firestore
class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.product,
    required super.quantity,
    super.selectedOptions,
    required super.userLocation,   // تغيير إحداثيات المستخدم إلى GeoPoint
  });

  /// من JSON إلى Model
  factory CartItemModel.fromJson(Map<String, dynamic> json, {String? id}) {
    final productJson = json['product'] ?? {};

    return CartItemModel(
      id: id ?? json['id'] ?? '',
      product: ProductEntity(
        id: productJson['id'] ?? '',
        name: productJson['name'] ?? '',
        nameAr: productJson['nameAr'] ?? productJson['name_ar'] ?? '',
        imageUrl: productJson['imageUrl'] ?? productJson['image'] ?? '',
        price: (productJson['price'] as num?)?.toDouble() ?? 0.0,
        isAvailable: productJson['isAvailable'] ?? true,
        categoryId: productJson['categoryId'] ?? productJson['category'] ?? '',
        branchIds: productJson['branchIds'] != null 
            ? List<String>.from(productJson['branchIds']) 
            : [],
        description: productJson['description'] ?? '',
        descriptionAr: productJson['descriptionAr'] ?? productJson['description_ar'] ?? '',
        discount: (productJson['discount'] as num?)?.toDouble() ?? 0.0,
        points: (productJson['points'] as num?)?.toInt() ?? 0,
        selectedSize: productJson['selectedSize'] ?? '',
        avaliableSize: productJson['avaliableSize'] != null
            ? List<String>.from(productJson['avaliableSize'])
            : productJson['availableSizes'] != null
                ? List<String>.from(productJson['availableSizes'])
                : [],
        sizes: [],
        extraOption: [],
      ),
      quantity: json['quantity'] ?? 1,
      selectedOptions: Map<String, dynamic>.from(json['selectedOptions'] ?? {}),
      userLocation: GeoPoint(
        (json['userLat'] as num?)?.toDouble() ?? 0.0,  // إضافة إحداثيات المستخدم
        (json['userLng'] as num?)?.toDouble() ?? 0.0,  // إضافة إحداثيات المستخدم
      ),
    );
  }

  /// من Model إلى JSON (لحفظها في SharedPreferences أو Firestore)
  Map<String, dynamic> toJson() {
    final p = product;
    return {
      'id': id,
      'product': {
        'id': p.id,
        'name': p.name,
        'nameAr': p.nameAr,
        'imageUrl': p.imageUrl,
        'price': p.price,
        'isAvailable': p.isAvailable,
        'categoryId': p.categoryId,
        'branchIds': p.branchIds,
        'description': p.description,
        'descriptionAr': p.descriptionAr,
        'discount': p.discount,
        'points': p.points,
        'selectedSize': p.selectedSize,
        'avaliableSize': p.avaliableSize,
      },
      'quantity': quantity,
      'selectedOptions': selectedOptions,
      'userLat': userLocation.latitude,  // إضافة إحداثيات المستخدم
      'userLng': userLocation.longitude,  // إضافة إحداثيات المستخدم
    };
  }

  /// من Entity إلى Model
  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      id: entity.id,
      product: entity.product,
      quantity: entity.quantity,
      selectedOptions: entity.selectedOptions,
      userLocation: entity.userLocation,  // إضافة إحداثيات المستخدم
    );
  }

  /// من Model إلى Entity
  CartItemEntity toEntity() {
    return CartItemEntity(
      id: id,
      product: product,
      quantity: quantity,
      selectedOptions: selectedOptions,
      userLocation: userLocation,  // إضافة إحداثيات المستخدم
    );
  }
}
