// lib/featurees/orders/domain/usecases/update_payment_usecase.dart


import 'package:appp/featurees/checkout_screens/order_screen/domain/repo/order_repo.dart';

/// Use Case لتحديث حالة الدفع COD
class UpdatePaymentUseCase {
  final OrderRepository repository;

  UpdatePaymentUseCase(this.repository);

  /// تنفذ العملية
  /// [orderId] = معرف الطلب
  /// [amount] = المبلغ الذي تم جمعه
  /// [collectedBy] = معرف الموظف الذي جمع الكاش
  Future<void> execute({
    required String orderId,
    required double amount,
    required String collectedBy,
  }) async {
    await repository.updatePayment(
      orderId: orderId,
      amount: amount,
      collectedBy: collectedBy,
    );
  }
}