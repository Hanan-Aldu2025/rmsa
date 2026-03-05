import 'package:appp/core/network_status/network_status.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/presentation/cubit/cubit_payment_method/payment_method_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethodCubit extends Cubit<PaymentMethodState> {
  PaymentMethodCubit() : super(const PaymentMethodState());

  void selectMethod(String methodId) {
    emit(state.copyWith(selectedMethodId: methodId));
  }

  Future<void> confirm() async {
    print('🟡=== confirm() called');

    final status = await NetworkInfo.checkConnection();
    print('🌐 Network status: $status');

    if (status != NetworkStatus.connected) {
      print('❌==== No internet, stop here');

      emit(
        state.copyWith(
          isConfirmed: false,
          errorMessage: NetworkInfo.message(status),
        ),
      );
      return;
    }

    print('✅=== Internet OK, confirm payment');

    emit(state.copyWith(isConfirmed: true, errorMessage: null));
  }

  void back() {
    emit(const PaymentMethodState());
  }
}
