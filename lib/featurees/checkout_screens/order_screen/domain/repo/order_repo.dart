import 'package:appp/featurees/checkout_screens/order_screen/domain/entity/order_entity.dart';

abstract class OrderRepository {
  /// إنشاء طلب جديد
  Future<void> createOrder(OrderEntity order);

  /// تحديث حالة الدفع COD بعد جمع الكاش
  Future<void> updatePayment({
    required String orderId,
    required double amount,
    required String collectedBy,
  });

  /// تحديث حالة الطلب (مثلاً: preparing, out_for_delivery, delivered)
  Future<void> updateOrderState({
    required String orderId,
    required String newState,
  });

  /// الحصول على الطلبات الخاصة بمستخدم معين (Realtime Stream)
  Stream<List<OrderEntity>> getOrdersForUser(String userId);

  /// الحصول على كل الطلبات للمقهى أو الموظف (مثلاً لجميع الموظفين)
  Stream<List<OrderEntity>> getAllOrders();

  /// الحصول على طلب محدد
  Future<OrderEntity> getOrderById(String orderId);
}