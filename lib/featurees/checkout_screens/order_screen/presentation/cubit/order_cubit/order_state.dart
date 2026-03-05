// lib/featurees/orders/presentation/cubit/order_state.dart

import 'package:appp/featurees/checkout_screens/order_screen/domain/entity/order_entity.dart';


/// الحالات المختلفة للـ OrderCubit
abstract class OrderState {}

/// الحالة الابتدائية
class OrderInitial extends OrderState {}

/// عند تحميل الطلبات
class OrderLoading extends OrderState {}

/// عند نجاح عملية معينة
class OrderSuccess extends OrderState {
  final String message;

  OrderSuccess(this.message);
}

/// عند فشل عملية معينة
class OrderFailure extends OrderState {
  final String error;

  OrderFailure(this.error);
}

/// عند استرجاع قائمة الطلبات (Realtime Stream)
class OrdersLoaded extends OrderState {
  final List<OrderEntity> orders;

  OrdersLoaded(this.orders);
}