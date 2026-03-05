// lib/featurees/orders/domain/usecases/create_order_usecase.dart


import 'package:appp/featurees/checkout_screens/order_screen/domain/entity/order_entity.dart';
import 'package:appp/featurees/checkout_screens/order_screen/domain/repo/order_repo.dart';

/// Use Case لإنشاء طلب جديد
class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  /// تنفذ العملية
  /// [order] = OrderEntity المطلوب إنشاؤه
  Future<void> execute(OrderEntity order) async {
    await repository.createOrder(order);
  }
}