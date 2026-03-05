import 'dart:async';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class MobilePaymentState {}

class MobilePaymentInitial extends MobilePaymentState {}

class MobilePaymentLoading extends MobilePaymentState {}

class MobilePaymentSuccess extends MobilePaymentState {
  final String orderId;
  MobilePaymentSuccess(this.orderId);
}

class MobilePaymentError extends MobilePaymentState {
  final String message;
  MobilePaymentError(this.message);
}

class MobilePaymentCubit extends Cubit<MobilePaymentState> {
  final CartCubit cartCubit;
  MobilePaymentCubit(this.cartCubit) : super(MobilePaymentInitial());
//=================================================================================//
  Future<void> payWithMobile() async {
    emit(MobilePaymentLoading());

    try {
      // 👇 محاكاة الدفع عبر بوابة حقيقية لاحقاً
      await Future.delayed(const Duration(seconds: 2));

      // 🔹 إنشاء الأوردر بالـ Firebase
      final orderRef = FirebaseFirestore.instance.collection('orders').doc();
      await orderRef.set({
        "userId": cartCubit.userId,
        "products": cartCubit.items
            .map(
              (e) => {
                "productId": e.product.id,
                "name": e.product.name,
                "price": e.product.price,
                "quantity": e.quantity,
                "total": e.product.price * e.quantity,
              },
            )
            .toList(),
        "total": cartCubit.totalWithTaxAndDelivery,
        "delivery": cartCubit.deliveryCost,
        "discount": cartCubit.discountValue,
        "pointsDiscount": cartCubit.discountValue,
        "paymentMethod": "MOBILE",
        "paymentStatus": "paid",
        "orderStatus": "pending",
        "orderNote": cartCubit.orderNote,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });

      emit(MobilePaymentSuccess(orderRef.id));

      // تنظيف السلة بعد الدفع
      cartCubit.resetCartAfterCheckout();
      cartCubit.clearCart();
    } catch (e) {
      emit(MobilePaymentError("تعذر إتمام الدفع: $e"));
    }
  }
}
