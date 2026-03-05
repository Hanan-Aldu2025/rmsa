abstract class CashPaymentState {}

class CashPaymentInitial extends CashPaymentState {}

class CashPaymentLoading extends CashPaymentState {}

class CashPaymentSuccess extends CashPaymentState {
  final String message;
  CashPaymentSuccess(this.message);
}
class CashPaymentReady extends CashPaymentState {}

class CashPaymentError extends CashPaymentState {
  final String message;
  CashPaymentError(this.message);
}
class CashPaymentUpdated extends CashPaymentState {}
