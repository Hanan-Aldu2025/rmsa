import 'package:appp/featurees/checkout_screens/order_screen/domain/entity/order_entity.dart';
import 'package:appp/featurees/checkout_screens/order_screen/domain/repo/order_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ===================== إنشاء طلب جديد =====================
  @override
  Future<void> createOrder(OrderEntity order) async {
    try {
      // 🔥 جلب بيانات الفرع مرة واحدة
      final branchDoc = await _firestore
          .collection('branches')
          .doc(order.branchId)
          .get();

      final branchData = branchDoc.data();
      final branchName = branchData?['name'] ?? 'Unknown Branch';
      final branchGeoPoint = branchData?['location'] as GeoPoint?;

      // إذا كان branchLocation null استخدم GeoPoint افتراضي
      final branchLocation = branchGeoPoint ?? GeoPoint(0.0, 0.0);

      // ===================== إنشاء OrderModel =====================
      final newOrder = OrderModel(
        id: '', // يتم توليده تلقائيًا من Firestore
        userId: order.userId,
        items: order.items,
        totalAmount: order.totalAmount,
        delivery: order.delivery,
        discount: order.discount,
        pointsDiscount: order.pointsDiscount,
        paymentMethod: order.paymentMethod,
        paymentStatus: order.paymentStatus,
        orderStatus: order.orderStatus,
        createdAt: order.createdAt,
        updatedAt: order.updatedAt,
        orderNote: order.orderNote,
        driverId: order.driver?.id,
        estimatedMinutes: int.tryParse(order.estimatedDeliveryTime) ?? 0,
        tax: order.tax,
        branchId: order.branchId,
        branchName: branchName,
        branchLocation: branchLocation,
        userLocation: order.userLocation ?? GeoPoint(0.0, 0.0),
        driverLocation: order.driverLocation ?? GeoPoint(0.0, 0.0),
        estimatedDeliveryTime: order.estimatedDeliveryTime,
      );

      // إضافة الطلب إلى Firestore
      final docRef = await _firestore
          .collection('orders')
          .add(newOrder.toMap());
      print('Order created successfully with id: ${docRef.id}');
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  /// ===================== تحديث الموقع COD =====================

  Future<void> updateDriverLocation({
    required String orderId,
    required GeoPoint newLocation,
  }) async {
    await _firestore.collection('orders').doc(orderId).update({
      'driverLocation': newLocation,
      'lastDriverLocationAt': FieldValue.serverTimestamp(),
    });
  }

  /// ===================== تحديث الدفع COD =====================
  @override
  Future<void> updatePayment({
    required String orderId,
    required double amount,
    required String collectedBy,
  }) async {
    try {
      // تحديث حالة الطلب
      await _firestore.collection('orders').doc(orderId).update({
        'payment_state': 'paid',
        'order_state': 'delivered',
        'updated_at': FieldValue.serverTimestamp(),
      });

      // إضافة سجل الدفع
      await _firestore.collection('payments').add({
        'order_id': orderId,
        'amount': amount,
        'method': 'COD',
        'status': 'paid',
        'collected_by': collectedBy,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update payment: $e');
    }
  }

  /// ===================== تحديث حالة الطلب =====================
  @override
  Future<void> updateOrderState({
    required String orderId,
    required String newState,
  }) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'order_state': newState,
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update order state: $e');
    }
  }

  /// ===================== جلب الطلبات لمستخدم معين (Realtime) =====================
  @override
  Stream<List<OrderEntity>> getOrdersForUser(String userId) {
    return _firestore
        .collection('orders')
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  /// ===================== جلب كل الطلبات (Realtime) =====================
  @override
  Stream<List<OrderEntity>> getAllOrders() {
    return _firestore
        .collection('orders')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  /// ===================== جلب طلب محدد =====================
  @override
  Future<OrderEntity> getOrderById(String orderId) async {
    try {
      final doc = await _firestore.collection('orders').doc(orderId).get();
      if (doc.exists) {
        return OrderModel.fromMap(doc.data()!, doc.id);
      } else {
        throw Exception('Order not found');
      }
    } catch (e) {
      throw Exception('Failed to get order: $e');
    }
  }
}
