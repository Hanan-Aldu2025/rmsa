import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/order_method_cubit/order_method_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryMethodCubit extends Cubit<DilveryMethodState> {
  DeliveryMethodCubit() : super(DilveryMethodState());

  void selectMethod(String methodId, Object object) {
    emit(state.copyWith(selectedMethod: methodId));

    // لو الطريقة ليست Delivery → نرجع نوع التوصيل ل null و deliveryPrice = 0
    if (methodId != 'delivery') {
      emit(state.copyWith(selectedDeliveryType: null, deliveryPrice: 0));
    }
  }

  void selectDeliveryType(String type, double price) {
    emit(state.copyWith(selectedDeliveryType: type, deliveryPrice: price));
  }
}
