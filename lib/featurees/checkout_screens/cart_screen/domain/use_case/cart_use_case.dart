import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/domain/entity/cart_item_entity.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/domain/repo/cart_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartUseCase {
  final List<CartItemEntity> _cartItems = [];
  final CartRepository _cartRepository;

  CartUseCase(this._cartRepository);

  List<CartItemEntity> get items => List.unmodifiable(_cartItems);
  double get totalPrice =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// ====================== إضافة منتج ======================
  void addToCart(
    ProductEntity product, {
    Map<String, dynamic>? selectedOptions,
    GeoPoint? userLocation,  // استخدام GeoPoint بدلاً من lat/lng
  }) {
    final options = selectedOptions ?? {};

    // البحث عن المنتج الموجود بالفعل بنفس الخيارات
    final index = _cartItems.indexWhere(
      (item) =>
          item.product.id == product.id &&
          _areOptionsEqual(item.selectedOptions ?? {}, options),
    );

    if (index != -1) {
      // المنتج موجود → زيادة الكمية
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: _cartItems[index].quantity + 1,
        userLocation: userLocation,  // تحديث الموقع باستخدام GeoPoint
      );
    } else {
      // منتج جديد → إضافة للـ Cart
      _cartItems.add(
        CartItemEntity(
          id: '', // ← سيتم تعيينه لاحقًا عند حفظه في Firestore
          product: product,
          quantity: 1,
          selectedOptions: options,
          userLocation: userLocation ?? GeoPoint(0.0, 0.0),  // إضافة الموقع باستخدام GeoPoint
        ),
      );
    }
  }

  /// ====================== تقليل كمية المنتج ======================
  void decreaseQuantity(
    ProductEntity product, {
    Map<String, dynamic>? selectedOptions,
    GeoPoint? userLocation,  // استخدام GeoPoint بدلاً من lat/lng
  }) {
    final index = _cartItems.indexWhere(
      (item) =>
          item.product.id == product.id &&
          _areOptionsEqual(item.selectedOptions, selectedOptions),
    );

    if (index != -1) {
      final currentItem = _cartItems[index];
      if (currentItem.quantity > 1) {
        _cartItems[index] = currentItem.copyWith(
          quantity: currentItem.quantity - 1,
          userLocation: userLocation,  // تحديث الموقع باستخدام GeoPoint
        );
      } else {
        removeFromCart(product, selectedOptions: selectedOptions);
      }
    }
  }

  /// ====================== إزالة منتج ======================
  void removeFromCart(
    ProductEntity product, {
    Map<String, dynamic>? selectedOptions,
  }) {
    _cartItems.removeWhere(
      (item) =>
          item.product.id == product.id &&
          _areOptionsEqual(item.selectedOptions, selectedOptions),
    );
  }

  /// ====================== تحديث كمية منتج ======================
  void updateQuantity(
    ProductEntity product,
    int newQuantity, {
    Map<String, dynamic>? selectedOptions,
    GeoPoint? userLocation,  // استخدام GeoPoint بدلاً من lat/lng
  }) {
    final index = _cartItems.indexWhere(
      (item) =>
          item.product.id == product.id &&
          _areOptionsEqual(item.selectedOptions, selectedOptions),
    );

    if (index == -1) return;

    if (newQuantity <= 0) {
      removeFromCart(product, selectedOptions: selectedOptions);
    } else {
      _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
    }
  }

  /// ====================== مسح السلة ======================
  void clearCart() => _cartItems.clear();

  /// ====================== تحديث محتوى السلة بالكامل ======================
  void setItems(List<CartItemEntity> items) {
    _cartItems.clear();
    _cartItems.addAll(items);
  }

  /// ====================== مقارنة الخيارات ======================
  bool _areOptionsEqual(Map<String, dynamic>? a, Map<String, dynamic>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;

final aString = a.entries.map((e) => '${e.key}:${e.value}').toList()
      ..sort();
    final bString = b.entries.map((e) => '${e.key}:${e.value}').toList()
      ..sort();

    return aString.join(',') == bString.join(',');
  }

  /// ====================== الحصول على الكمية ======================
  int getQuantity(ProductEntity product, {Map<String, dynamic>? selectedOptions, GeoPoint? userLocation}) {
    final item = _cartItems.firstWhere(
      (e) => e.product.id == product.id &&
           _areOptionsEqual(e.selectedOptions, selectedOptions),
      orElse: () => CartItemEntity(
        product: product, 
        id: '', 
        quantity: 0, 
        userLocation: userLocation ?? GeoPoint(0.0, 0.0),  // إذا كانت null، سيتم تعيين قيمة GeoPoint(0.0, 0.0)
      ),
    );
    return item.quantity;
  }
}