// lib/featurees/orders/presentation/cubit/order_cubit.dart

import 'package:appp/featurees/checkout_screens/order_screen/domain/entity/order_entity.dart';
import 'package:appp/featurees/checkout_screens/order_screen/domain/use_case/order_use_case.dart';
import 'package:appp/featurees/checkout_screens/order_screen/domain/use_case/payment_use_case.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/cubit/order_cubit/order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit لإدارة الطلبات
class OrderCubit extends Cubit<OrderState> {
  final CreateOrderUseCase createOrderUseCase;
  final UpdatePaymentUseCase updatePaymentUseCase;

  OrderCubit({
    required this.createOrderUseCase,
    required this.updatePaymentUseCase,
  }) : super(OrderInitial());

  //_________________________________________________________//
  List<OrderItem> cartItems = []; // السلة
  double discount = 0; // خصم عام على الطلب
  double pointsDiscount = 0; // خصم نقاط المستخدم
  double deliveryFee = 5.0; // رسوم التوصيل

  /// حساب Subtotal بعد خصم خصم العناصر فقط
  double calculateSubtotal() {
    double subtotal = 0;
    for (var item in cartItems) {
      subtotal += (item.price - item.discount) * item.quantity;
    }
    return subtotal;
  }

  /// حساب المجموع النهائي: Subtotal + DeliveryFee - خصم عام - خصم نقاط المستخدم
  double calculateTotal() {
    double subtotal = calculateSubtotal();

    // خصم عام على الطلب
    subtotal -= discount;

    // إضافة رسوم التوصيل
    double total = subtotal + deliveryFee;

    // خصم نقاط المستخدم
    total -= pointsDiscount;

    // ضمان عدم أن يكون المجموع سالب
    if (total < 0) total = 0;

    return total;
  }

  //___________________________________________________________//

  /// إنشاء طلب جديد
  Future<void> createOrder(OrderEntity order) async {
    emit(OrderLoading());
    try {
      await createOrderUseCase.execute(order);
      emit(OrderSuccess("Order created successfully!"));
    } catch (e) {
      emit(OrderFailure("Failed to create order: $e"));
    }
  }

  /// تحديث الدفع COD
  Future<void> confirmCODPayment({
    required String orderId,
    required double amount,
    required String collectedBy,
  }) async {
    emit(OrderLoading());
    try {
      await updatePaymentUseCase.execute(
        orderId: orderId,
        amount: amount,
        collectedBy: collectedBy,
      );
      emit(OrderSuccess("Payment confirmed successfully!"));
    } catch (e) {
      emit(OrderFailure("Failed to confirm payment: $e"));
    }
  }

  /// متابعة قائمة الطلبات للمستخدم (Realtime Stream)
  void streamOrders(Stream<List<OrderEntity>> ordersStream) {
    emit(OrderLoading());
    ordersStream.listen(
      (orders) => emit(OrdersLoaded(orders)),
      onError: (e) => emit(OrderFailure("Failed to load orders: $e")),
    );
  }
}
