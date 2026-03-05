import 'dart:convert';
import 'package:appp/featurees/Location/location_serveice.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/domain/entity/cart_item_entity.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/domain/repo/cart_repo.dart';

class CartRepositoryImpl implements CartRepository {
  final List<CartItemEntity> _cartItems = [];
  List<CartItemEntity> get items => List.unmodifiable(_cartItems);

  double get totalPrice =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get userId => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get _userCartCollection =>
      _firestore.collection('carts').doc(userId).collection('items');

  final LocationService _locationService = LocationService();

  String _optionsKey(Map<String, dynamic>? options) {
    if (options == null || options.isEmpty) return '';
    final sortedKeys = options.keys.toList()..sort();
    final mapSorted = {for (var k in sortedKeys) k: options[k]};
    final jsonStr = jsonEncode(mapSorted);
    final bytes = utf8.encode(jsonStr);
    return sha1.convert(bytes).toString();
  }

  bool _areOptionsEqual(Map<String, dynamic>? a, Map<String, dynamic>? b) {
    a ??= {};
    b ??= {};
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  String _docIdForItem(ProductEntity product, Map<String, dynamic>? options) {
    final optKey = _optionsKey(options);
    return optKey.isEmpty ? product.id : '${product.id}_$optKey';
  }

  @override
  Future<void> loadCartFromFirestore() async {
    final snapshot = await _userCartCollection.get();
    _cartItems.clear();

    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final selectedOptions = Map<String, dynamic>.from(
        data['selectedOptions'] ?? {},
      );

      // ===================== معالجة userLocation =====================
      GeoPoint userLocation;

      if (data['userLocation'] is GeoPoint) {
        // إذا كان GeoPoint مباشرة
        userLocation = data['userLocation'] as GeoPoint;
      } else if (data['userLat'] != null && data['userLng'] != null) {
        // إذا كان مخزن كـ lat/lng منفصل
        userLocation = GeoPoint(
          (data['userLat'] as num).toDouble(),
          (data['userLng'] as num).toDouble(),
        );
      } else {
        // fallback على الموقع الحالي أو GeoPoint افتراضي
        try {
          final pos = await _locationService.getCurrentLocation();
          userLocation = GeoPoint(pos.latitude, pos.longitude);
        } catch (_) {
          userLocation = GeoPoint(0.0, 0.0);
        }
      }

      _cartItems.add(
        CartItemEntity(
          id: doc.id,
          product: ProductEntity(
            id: data['productId'] ?? doc.id.split('_').first,
            name: data['name'] ?? '',
            nameAr: data['nameAr'] ?? data['name'] ?? '',
            imageUrl: data['imageUrl'] ?? data['image'] ?? '',
            price: (data['price'] is int)
                ? (data['price'] as int).toDouble()
                : (data['price'] ?? 0.0).toDouble(),
            isAvailable: data['isAvailable'] ?? true,
            categoryId: data['categoryId'] ?? '',
            branchIds: data['branchIds'] != null 
                ? List<String>.from(data['branchIds']) 
                : [],
            description: data['description'] ?? '',
            descriptionAr: data['descriptionAr'] ?? '',
            discount: (data['discount'] ?? 0.0).toDouble(),
            points: (data['points'] ?? 0).toInt(),
            selectedSize: data['selectedSize'] ?? '',
            avaliableSize: data['avaliableSize'] != null
                ? List<String>.from(data['avaliableSize'])
                : [],
            sizes: [],
            extraOption: [],
          ),
          quantity: (data['quantity'] ?? 1) as int,
          selectedOptions: selectedOptions,
          userLocation: userLocation, // استخدم GeoPoint النهائي
        ),
      );
    }
  }

  /// ===================== إضافة منتج للسلة =====================
  @override
  Future<void> addToCart(
    ProductEntity product, {
    Map<String, dynamic>? selectedOptions,
  }) async {
    final options = selectedOptions ?? {};
    final index = _cartItems.indexWhere(
      (item) =>
          item.product.id == product.id &&
          _areOptionsEqual(item.selectedOptions, options),
    );

    GeoPoint geoPoint;
    try {
      final userLocation = await _locationService.getCurrentLocation();
      geoPoint = GeoPoint(userLocation.latitude, userLocation.longitude);
    } catch (_) {
      geoPoint = GeoPoint(0.0, 0.0);
    }

    if (index != -1) {
      // المنتج موجود → زيادة الكمية
      final updatedItem = _cartItems[index].copyWith(
        quantity: _cartItems[index].quantity + 1,
        userLocation: geoPoint,
      );
      _cartItems[index] = updatedItem;

      // تحديث Firestore
      await _userCartCollection.doc(updatedItem.id).update({
        "quantity": updatedItem.quantity,
        "userLocation": geoPoint,
      });
    } else {
      // منتج جديد → إضافة
      final docRef = await _userCartCollection.add({
        "productId": product.id,
        "name": product.name,
        "price": product.price,
        "quantity": 1,
        "selectedOptions": options,
        "imageUrl": product.imageUrl,
        "userLocation": geoPoint,
      });

      _cartItems.add(
        CartItemEntity(
          id: docRef.id,
          product: product,
          quantity: 1,
          selectedOptions: options,
          userLocation: geoPoint,
        ),
      );
    }
  }

  /// ===================== إزالة منتج من السلة =====================
  @override
  Future<void> removeFromCart(
    ProductEntity product, {
    Map<String, dynamic>? selectedOptions,
  }) async {
    final index = _cartItems.indexWhere(
      (item) =>
          item.product.id == product.id &&
          _areOptionsEqual(item.selectedOptions, selectedOptions),
    );
    if (index != -1) {
      final removedItem = _cartItems.removeAt(index);
      await _userCartCollection.doc(removedItem.id).delete();
    }
  }

  /// ===================== تعديل الكمية =====================
  @override
  Future<void> updateQuantity(
    ProductEntity product,
    int newQuantity, {
    Map<String, dynamic>? selectedOptions,
  }) async {
    final index = _cartItems.indexWhere(
      (item) =>
          item.product.id == product.id &&
          _areOptionsEqual(item.selectedOptions, selectedOptions),
    );

    if (index == -1) return;

    if (newQuantity <= 0) {
      final removedItem = _cartItems.removeAt(index);
      await _userCartCollection.doc(removedItem.id).delete();
    } else {
      GeoPoint geoPoint;
      try {
        final userLocation = await _locationService.getCurrentLocation();
        geoPoint = GeoPoint(userLocation.latitude, userLocation.longitude);
      } catch (_) {
        geoPoint = _cartItems[index].userLocation;
      }

      _cartItems[index] = _cartItems[index].copyWith(
        quantity: newQuantity,
        userLocation: geoPoint,
      );

      await _userCartCollection.doc(_cartItems[index].id).update({
        "quantity": _cartItems[index].quantity,
        "userLocation": geoPoint,
      });
    }
  }

  /// ===================== مسح كل السلة =====================
  @override
  Future<void> clearCart() async {
    final snapshot = await _userCartCollection.get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
    _cartItems.clear();
  }
}
