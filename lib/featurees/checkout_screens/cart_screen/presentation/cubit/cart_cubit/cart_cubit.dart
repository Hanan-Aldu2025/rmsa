import 'package:appp/featurees/checkout_screens/order_screen/data/models/driver_model.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/domain/entity/cart_item_entity.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/domain/entity/delivery_options_entity_and_model.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/domain/use_case/cart_use_case.dart';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_state.dart';
import 'package:appp/featurees/checkout_screens/order_screen/data/repo_imp/driver_repo_imp.dart';
import 'package:appp/featurees/main_screens/offers_screen/data/model/offer_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  final CartUseCase _cartUseCase;
  String? selectedBranchId;
   DriverModel? selectedDriver;
  bool _isCartInitialized = false;
  String orderNote = " ";
  String userId = '';
  List<CartItemEntity> get items => _cartUseCase.items;

  // ===================== Delivery =====================
  String? deliveryMethod;
  double deliveryCost = 0.0;
  List<DeliveryOption> deliveryOptions = [];

  // ===================== Discount =====================
  double discountValue = 0.0;
  String? appliedDiscountCode;
  String? discountErrorMessage;

  // ===================== Tax =====================
  double taxValue = 0.0;

  CartCubit(this._cartUseCase) : super(CartInitial()) {
    _initCart();
  }

  // ===================== Init =====================
  Future<void> _initCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid; // 🔹 تعيين userId
    }
    await loadCartFromFirestore();
    await fetchTaxFromFirestore();
    _isCartInitialized = true;
  }

  // ===================== UserId =====================
  void setUserId(String id) {
    userId = id;
  }

  // ===================== Update Branch =====================
  void setSelectedBranchId(String branchId) {
    selectedBranchId = branchId;
    emitUpdated(); // تحديث الـ state بعد التغيير
  }

  // ===================== Load Cart =====================
  Future<void> loadCartFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(const CartUpdated(items: [], totalPrice: 0.0, orderNote: ''));
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('carts')
        .doc(user.uid)
        .collection('items')
        .get();

    final cartItems = snapshot.docs.map((doc) {
      final data = doc.data();
      final productData = data['product'] ?? {};

      // ===================== GeoPoint =====================
      GeoPoint userLocation;
      final userLat = data['userLat'];
      final userLng = data['userLng'];

      if (userLat != null && userLng != null) {
        userLocation = GeoPoint(
          (userLat as num).toDouble(),
          (userLng as num).toDouble(),
        );
      } else if (data['userLocation'] is GeoPoint) {
        userLocation = data['userLocation'] as GeoPoint;
      } else {
        userLocation = GeoPoint(0.0, 0.0);
      }

      return CartItemEntity(
        id: doc.id,
        product: ProductEntity(
          id: productData['id'] ?? '',
          name: productData['name'] ?? '',
          nameAr: productData['nameAr'] ?? productData['name'] ?? '',
          imageUrl: productData['imageUrl'] ?? productData['image'] ?? '',
          price: (productData['price'] as num?)?.toDouble() ?? 0.0,
          isAvailable: productData['isAvailable'] ?? true,
          categoryId: productData['categoryId'] ?? '',
          branchIds: productData['branchIds'] != null 
              ? List<String>.from(productData['branchIds']) 
              : [],
          description: productData['description'] ?? '',
          descriptionAr: productData['descriptionAr'] ?? '',
          discount: (productData['discount'] as num?)?.toDouble() ?? 0.0,
          points: (productData['points'] as num?)?.toInt() ?? 0,
          selectedSize: productData['selectedSize'] ?? '',
          avaliableSize: productData['avaliableSize'] != null
              ? List<String>.from(productData['avaliableSize'])
              : [],
          sizes: [],
          extraOption: [],
        ),
        quantity: data['quantity'] ?? 1,
        selectedOptions: Map<String, dynamic>.from(
          data['selectedOptions'] ?? {},
        ),
        userLocation: userLocation, // الموقع جاهز كـ GeoPoint
      );
    }).toList();

    _cartUseCase.setItems(cartItems);
    emitUpdated();
  }

  // ===================== Save Cart =====================
  Future<void> _saveCartToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final itemsRef = FirebaseFirestore.instance
        .collection('carts')
        .doc(user.uid)
        .collection('items');

    final batch = FirebaseFirestore.instance.batch();

    final oldItems = await itemsRef.get();
    for (final doc in oldItems.docs) {
      batch.delete(doc.reference);
    }

    for (final item in _cartUseCase.items) {
      final docRef = item.id.isEmpty ? itemsRef.doc() : itemsRef.doc(item.id);
      batch.set(docRef, {
        'product': {
          'id': item.product.id,
          'name': item.product.name,
          'image': item.product.imageUrl,
          'price': item.product.price,
        },
        'quantity': item.quantity,
        'selectedOptions': item.selectedOptions ?? {},
        'userLat': item.userLocation.latitude,
        'userLng': item.userLocation.longitude,
      });
    }

    await batch.commit();
  }

  // ===================== Cart Actions =====================
  // Future<void> addProduct(
  //   ProductEntity product, {
  //   Map<String, dynamic>? selectedOptions,
  //   GeoPoint? userLocation, // تغيير الموقع إلى GeoPoint
  // }) async {
  //   if (!_isCartInitialized) {
  //     await _initCart();
  //   }

  //   _cartUseCase.addToCart(
  //     product,
  //     selectedOptions: selectedOptions,
  //     userLocation: userLocation,
  //   );
  //   emitUpdated();
  //   await _saveCartToFirestore();
  // }
  //-===============================================================================//
  Future<void> addProduct(
  ProductEntity product, {
  Map<String, dynamic>? selectedOptions,
  GeoPoint? userLocation,
}) async {
  if (!_isCartInitialized) {
    await _initCart();
  }

  // تحقق من العروض الخاصة بالمنتج قبل إضافته
  final offer = await _checkForOffer(product);

  if (offer != null) {
    _applyOffer(product, offer);  // تطبيق العرض على المنتج
  }

  _cartUseCase.addToCart(
    product,
    selectedOptions: selectedOptions,
    userLocation: userLocation,
  );
  emitUpdated();
  await _saveCartToFirestore();
}

Future<OfferModel?> _checkForOffer(ProductEntity product) async {
  // هنا نتأكد من العروض المطبقة من قاعدة البيانات
  final offerQuerySnapshot = await FirebaseFirestore.instance
      .collection('offers') // استعلام إلى Collection العروض
      .where('applicableToAll', isEqualTo: true) // العروض التي تنطبق على الكل
      .get();

  // جلب العروض المرتبطة بهذا المنتج باستخدام associatedProducts
  final associatedOffers = offerQuerySnapshot.docs
      .where((doc) {
        final offerData = doc.data();
        final associatedProducts = List<String>.from(offerData['associatedProducts']);
        return associatedProducts.contains(product.id);
      })
      .map((doc) => OfferModel.fromMap(doc.data()))
      .toList();

  // إذا وجدنا عروض مرتبطة بالمنتج، نرجع العرض الأول
  if (associatedOffers.isNotEmpty) {
    return associatedOffers.first;
  }

  return null; // لا توجد عروض لهذا المنتج
}
//------------------------------------------------------------------------//
void _applyOffer(ProductEntity product, OfferModel offer) {
  if (offer.title == "Buy 5 items, get the 6th free") {
    // هنا نعيد الكائن مع تعديل السعر
    product = product.copyWith(price: 0.0); // سادس كوب مجانًا
  } else {
    // تحويل discount من String إلى double
    double discountValue = double.tryParse(offer.discount) ?? 0.0;

    // هنا نعيد الكائن مع تطبيق الخصم على السعر
    product = product.copyWith(price: product.price * (1 - discountValue / 100));
  }
  // الآن يمكنك التعامل مع المنتج المعدل (product)
}
//===================================================================================================//
  Future<void> decreaseProduct(
    ProductEntity product, {
    Map<String, dynamic>? selectedOptions,
  }) async {
    _cartUseCase.decreaseQuantity(product, selectedOptions: selectedOptions);
    await _saveCartToFirestore();
    emitUpdated();
  }

  Future<void> removeProduct(
    ProductEntity product, {
    Map<String, dynamic>? selectedOptions,
  }) async {
    _cartUseCase.removeFromCart(product, selectedOptions: selectedOptions);
    await _saveCartToFirestore();
    emitUpdated();
  }

  void updateOrderNote(String note) {
    orderNote = note;

    emit(
      CartUpdated(
        items: items,
        totalPrice: totalWithTaxAndDelivery,
        deliveryOptions: deliveryOptions,
        orderNote: orderNote,
      ),
    );
  }

  Future<void> clearCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final itemsRef = FirebaseFirestore.instance
        .collection('carts')
        .doc(user.uid)
        .collection('items');

    final snapshot = await itemsRef.get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }

    _cartUseCase.clearCart();
    emit(const CartUpdated(items: [], totalPrice: 0.0, orderNote: ''));
  }

  // ===================== Delivery =====================
  
  /// Check if there's an available driver (isActive == true AND isAvailable == true)
  Future<bool> isDriverAvailable() async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('drivers')
        .where('isAvailable', isEqualTo: true) // 🔥 فقط هذا الشرط
        .get();

    print("📦 Drivers found: ${snapshot.docs.length}");

    return snapshot.docs.isNotEmpty;
  } catch (e) {
    print("❌ Error checking driver availability: $e");
    return false;
  }
}
// داخل CartCubit
Future<void> fetchDeliveryOptions() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('delivery_options')
      .get();

  final allOptions = snapshot.docs
      .map((doc) => DeliveryOption.fromFirestore(doc.data(), doc.id))
      .toList();

  // فحص توافر السائقين
  final snapshotDrivers = await FirebaseFirestore.instance
      .collection('drivers')
      .where('isAvailable', isEqualTo: true)
      .limit(1)
      .get();

  final driverAvailable = snapshotDrivers.docs.isNotEmpty;
  print("🔍 Driver available: $driverAvailable");

  // إذا كان السائق متاحًا، خزّن بياناته
  selectedDriver = driverAvailable
      ? DriverModel.fromMap(snapshotDrivers.docs.first.data(), snapshotDrivers.docs.first.id)
      : null;

  // تعيين deliveryOptions ديناميكيًا
  deliveryOptions = allOptions.map((option) {
    if (option.name != "Pick Up") {
      return DeliveryOption(
        id: option.id,
        name: option.name,
        extraPrice: option.extraPrice,
        isActive: driverAvailable, // يعتمد فقط على isAvailable
        type: option.type,
        estimatedTime: option.estimatedTime,
      );
    }
    return option;
  }).toList();

  emitUpdated();
}

//============================================================================//

  // void selectDriver(DriverModel driver) {
  //   selectedDriver = driver;
  //   emit(CartDriverSelected(driver: driver));
  // }


void selectDeliveryOption(DeliveryOption option) {
    deliveryMethod = option.name;
    deliveryCost = option.extraPrice;

    emit(
      CartDeliveryOptionSelected(
        selectedOption: option,
        items: _cartUseCase.items,
        totalPrice: totalWithTaxAndDelivery,
        orderNote: '',
      ),
    );
  }

  // ===================== Discount =====================
  Future<void> applyDiscountCode(String code) async {
    try {
      discountErrorMessage = null;
      discountValue = 0.0;
      appliedDiscountCode = null;

      final doc = await FirebaseFirestore.instance
          .collection('discounts')
          .doc(code)
          .get();

      if (!doc.exists || doc.data()?['isActive'] != true) {
        discountErrorMessage = "كود الخصم غير صالح";
        emitUpdated();
        return;
      }

      final data = doc.data()!;
      final minOrder = (data['minOrder'] ?? 0).toDouble();

      if (productsTotal < minOrder) {
        discountErrorMessage = "الحد الأدنى للطلب $minOrder";
        emitUpdated();
        return;
      }

      final value = (data['value'] ?? 0).toDouble();
      discountValue = data['type'] == 'percentage'
          ? productsTotal * (value / 100)
          : value;

      appliedDiscountCode = code;
      emitUpdated();
    } catch (_) {
      discountErrorMessage = "حدث خطأ أثناء تطبيق الخصم";
      emitUpdated();
    }
  }

  // ===================== Tax =====================
  Future<void> fetchTaxFromFirestore() async {
    final doc = await FirebaseFirestore.instance
        .collection('settings')
        .doc('cartSettings')
        .get();

    if (doc.exists) {
      taxValue = (doc.data()?['taxValue'] ?? 0).toDouble();
      emitUpdated();
    }
  }

  // ===================== Totals =====================
  // double get productsTotal {
  //   return _cartUseCase.items.fold(
  //     0.0,
  //     (sum, item) => sum + (item.product.price * item.quantity),
  //   );
  // }
  double get productsTotal {
  return _cartUseCase.items.fold(
    0.0,
    (sum, item) => sum + (item.product.price * item.quantity),
  );
}

double get totalWithTaxAndDelivery {
  final total = productsTotal - discountValue;
  return total < 0 ? 0 : total + deliveryCost + taxValue;
}
//---------------------------------------------------------------------------//
  double get totalAfterDiscount {
    final total = productsTotal - discountValue;
    return total < 0 ? 0 : total;
  }

  // double get totalWithTaxAndDelivery {
  //   return totalAfterDiscount + deliveryCost + taxValue;
  // }

  // ===================== Emit =====================
  void emitUpdated() {
    final currentState = state;

    emit(
      CartUpdated(
        items: _cartUseCase.items,
        totalPrice: totalWithTaxAndDelivery,
        deliveryOptions: deliveryOptions,
        orderNote: currentState is CartUpdated ? currentState.orderNote : '',
      ),
    );
  }

  // ===================== Reset Cart =====================
  void resetCartAfterCheckout() {
    deliveryMethod = null;
    deliveryCost = 0;
    discountValue = 0;
    emit(
      CartUpdated(
        deliveryOptions: deliveryOptions,
        items: [],
        totalPrice: 0,
        orderNote: '',
      ),
    );
  }
}
