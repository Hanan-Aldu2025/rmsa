import 'dart:async';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:appp/featurees/checkout_screens/order_screen/data/models/order_model.dart';
import 'package:appp/featurees/checkout_screens/order_screen/domain/entity/order_entity.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/cubit/order_tracking_cubit/order_tracking_cubit.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/widget/order_tracking_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ===============================
/// STATES
/// ===============================
abstract class CardPaymentState {}

class CardPaymentInitial extends CardPaymentState {}

class CardPaymentLoading extends CardPaymentState {}

class CardPaymentSuccess extends CardPaymentState {
  final String orderId;
  CardPaymentSuccess({required this.orderId});
}

class CardPaymentError extends CardPaymentState {
  final String message;
  CardPaymentError(this.message);
}

/// ===============================
/// MOCK RESULT ENUM
/// ===============================
enum MockPaymentResult { success, failed, invalid }

/// ===============================
/// CUBIT
/// ===============================
class CardPaymentCubit extends Cubit<CardPaymentState> {
  final CartCubit cartCubit;
  late StreamSubscription cartSubscription;

  CardPaymentCubit({required this.cartCubit}) : super(CardPaymentInitial()) {
    cartSubscription = cartCubit.stream.listen((_) {});
  }

  @override
  Future<void> close() {
    cartSubscription.cancel();
    return super.close();
  }

  /// ===============================
  /// PAY (Mock Card Payment)
  /// ===============================
  Future<void> pay({
    required String cardNumber,
    required String expiry,
    required String cvv,
    required String holderName,
  }) async {
    emit(CardPaymentLoading());

    await Future.delayed(const Duration(seconds: 2));

    final result = _mockGateway(cardNumber);

    if (result == MockPaymentResult.success) {
      final orderId = await createCardOrderInFirebase();
      emit(CardPaymentSuccess(orderId: orderId));
      // الانتقال لصفحة التتبع بعد نجاح الدفع
      print("💚 PaymentSuccess emitted with id: $orderId");
    } else if (result == MockPaymentResult.failed) {
      emit(CardPaymentError('Payment failed, please try another card'));
    } else {
      emit(CardPaymentError('Invalid card details'));
    }
  }

  /// ===============================
  /// MOCK GATEWAY
  /// ===============================
  MockPaymentResult _mockGateway(String cardNumber) {
    if (cardNumber.startsWith('4242')) return MockPaymentResult.success;
    if (cardNumber.startsWith('4000')) return MockPaymentResult.failed;
    return MockPaymentResult.invalid;
  }

  /// ===============================
  /// CREATE ORDER (CARD)
  /// ===============================
  Future<String> createCardOrderInFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    final orderRef = FirebaseFirestore.instance.collection("orders").doc();

    await orderRef.set({
      "userId": user?.uid,
      "paymentMethod": "CARD",
      "paymentStatus": "paid",
      "orderStatus": "pending",
      "subtotal": cartCubit.productsTotal,
      "tax": cartCubit.taxValue,
      "delivery": cartCubit.deliveryCost,
      "discount": cartCubit.discountValue,
      "total": cartCubit.totalWithTaxAndDelivery,
      "orderNote": cartCubit.orderNote,
      "products": cartCubit.items.map((item) {
        return {
          "productId": item.product.id,
          "name": item.product.name,
          "price": item.product.price,
          "quantity": item.quantity,
          "total": item.product.price * item.quantity,
        };
      }).toList(),
      "createdAt": FieldValue.serverTimestamp(),
    });

    return orderRef.id;
  }

/// ===============================
  /// GO TO ORDER TRACKING
  /// ===============================
  Future<void> goToOrderTracking({
    required BuildContext context,
    required String orderId,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    // 🔄 stream الطلب
    final Stream<OrderEntity> orderStream = FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .snapshots()
        .map((snapshot) {
          final data = snapshot.data();
          return OrderModel.fromMap(data!, snapshot.id);
        });

    // 🚀 الانتقال
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => OrderTrackingCubit(),
          child: OrderTrackingPage(
            
          ),
        ),
      ),
    );

    // ♻️ تنظيف السلة
    cartCubit.resetCartAfterCheckout();
    cartCubit.clearCart();
  }
}