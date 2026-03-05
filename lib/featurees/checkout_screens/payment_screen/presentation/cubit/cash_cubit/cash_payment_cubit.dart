import 'dart:async';
import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:appp/featurees/checkout_screens/order_screen/data/repo_imp/driver_repo_imp.dart';
import 'package:appp/featurees/checkout_screens/payment_screen/models/cash_payment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cash_payment_state.dart';

class CashPaymentCubit extends Cubit<CashPaymentState> {
  final CartCubit cartCubit;
  final DriverRepository driverRepository;

  CashPaymentCubit(this.cartCubit, this.driverRepository)
    : super(CashPaymentInitial());

  double get finalTotal {
    final total =
        cartCubit.totalAfterDiscount +
        cartCubit.deliveryCost +
        cartCubit.taxValue;
    return total < 0 ? 0 : total;
  }

  Future<void> confirmCashOrder() async {
    emit(CashPaymentLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(CashPaymentError("يجب تسجيل الدخول لإتمام الطلب"));
        return;
      }

      if (cartCubit.items.isEmpty) {
        emit(CashPaymentError("السلة فارغة"));
        return;
      }

      String driverIdValue = '';
      String driverName = ''; // إضافة بيانات السائق
      String driverPhone = ''; // إضافة بيانات السائق
      String driverImage = ''; // إضافة بيانات السائق
      String branchIdValue = cartCubit.selectedBranchId ?? '';
      String orderStatusValue = 'pending';

      String branchNameValue = 'Unknown Branch';
      double branchLatValue = 0.0;
      double branchLngValue = 0.0;

      if (branchIdValue.isNotEmpty) {
        final branchDoc = await FirebaseFirestore.instance
            .collection('branches')
            .doc(branchIdValue)
            .get();

        final branchData = branchDoc.data();
        branchNameValue = branchData?['name'] ?? 'Unknown Branch';
        branchLatValue = (branchData?['lat'] ?? 0).toDouble();
        branchLngValue = (branchData?['lng'] ?? 0).toDouble();
      }

      // التحقق من وجود سائق
      if (cartCubit.deliveryCost > 0) {
        final driver = cartCubit.selectedDriver;
        if (driver == null) {
          emit(CashPaymentError("لا يوجد سائق متاح الآن"));
          return;
        }
        driverIdValue = driver.id;
        driverName = driver.name;
        driverPhone = driver.phone;
        driverImage = driver.imageUrl; // تأكد من أن هذه البيانات موجودة
      }

      int estimatedMinutesValue = 30; // الوقت المتوقع

      final cashOrder = CashPaymentModel(
        userId: user.uid,
        paymentMethod: "COD",
        paymentStatus: "pending",
        delivery: cartCubit.deliveryCost,
        tax: cartCubit.taxValue,
        discount: cartCubit.discountValue,
        total: finalTotal,
        orderNote: cartCubit.orderNote,
        createdAt: Timestamp.now(),
        driverId: driverIdValue,
        driverName: driverName, // تخزين اسم السائق
        driverPhone: driverPhone, // تخزين رقم الهاتف
        driverImage: driverImage, // تخزين صورة السائق
        branchId: branchIdValue,
        orderStatus: orderStatusValue,
        branchName: branchNameValue,
        branchLat: branchLatValue,
        branchLng: branchLngValue,
        estimatedMinutes: estimatedMinutesValue,
        products: cartCubit.items
            .map(
              (item) => {
                "product_id": item.product.id,
                "name": item.product.name,
                "price": item.product.price,
                "quantity": item.quantity,
                "discount": 0.0,
              },
            )
            .toList(),
      );

      await FirebaseFirestore.instance
          .collection("orders")
          .add(cashOrder.toMap())
          .timeout(const Duration(seconds: 10));

      if (isClosed) return;

      emit(CashPaymentSuccess("تم إنشاء الطلب بنجاح"));
    } on TimeoutException {
      if (isClosed) return;
      emit(CashPaymentError("انتهى وقت الاتصال، حاول مرة أخرى"));
    } catch (e) {
      if (isClosed) return;
      emit(CashPaymentError("حدث خطأ أثناء إنشاء الطلب"));
    }
  }
}
// import 'dart:async';
// import 'package:appp/featurees/checkout_screens/cart_screen/presentation/cubit/cart_cubit/cart_cubit.dart';
// import 'package:appp/featurees/checkout_screens/order_screen/data/repo_imp/driver_repo_imp.dart';
// import 'package:appp/featurees/checkout_screens/payment_screen/models/cash_payment_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'cash_payment_state.dart';

// class CashPaymentCubit extends Cubit<CashPaymentState> {
//   final CartCubit cartCubit;
//   final DriverRepository driverRepository;

//   CashPaymentCubit(this.cartCubit, this.driverRepository)
//       : super(CashPaymentInitial());

//   double get finalTotal {
//     final total =
//         cartCubit.totalAfterDiscount + cartCubit.deliveryCost + cartCubit.taxValue;
//     return total < 0 ? 0 : total;
//   }

//   /// ============================
//   /// تأكيد طلب الكاش
//   /// ============================
//   Future<void> confirmCashOrder() async {
//     emit(CashPaymentLoading());

//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         emit(CashPaymentError("يجب تسجيل الدخول لإتمام الطلب"));
//         return;
//       }

//       if (cartCubit.items.isEmpty) {
//         emit(CashPaymentError("السلة فارغة"));
//         return;
//       }

//       // ============================
//       // الإعدادات الأساسية
//       // ============================
//       String driverIdValue = '';
//       String driverName = '';
//       String driverPhone = '';
//       String driverImage = '';
//       String branchIdValue = cartCubit.selectedBranchId ?? '';
//       String orderStatusValue = 'pending';
//       String branchNameValue = 'Unknown Branch';
//       double branchLatValue = 0.0;
//       double branchLngValue = 0.0;

//       // ============================
//       // بيانات الفرع
//       // ============================
//       if (branchIdValue.isNotEmpty) {
//         final branchDoc =
//             await FirebaseFirestore.instance.collection('branches').doc(branchIdValue).get();
//         final branchData = branchDoc.data();
//         branchNameValue = branchData?['name'] ?? 'Unknown Branch';
//         branchLatValue = (branchData?['lat'] ?? 0).toDouble();
//         branchLngValue = (branchData?['lng'] ?? 0).toDouble();
//       }

//       // ============================
//       // التحقق من وجود سائق
//       // ============================
//       if (cartCubit.deliveryCost > 0) {
//         final driver = cartCubit.selectedDriver;
//         if (driver == null) {
//           emit(CashPaymentError(
//               "الدليفري مشغولين حالياً، سيتم إبلاغك عند توفر سائق"));
//           return;
//         }
//         driverIdValue = driver.id;
//         driverName = driver.name;
//         driverPhone = driver.phone;
//         driverImage = driver.imageUrl;
//         orderStatusValue = 'pending'; // تغيير الحالة عند وجود سائق
//       }

//       int estimatedMinutesValue = 30; // الوقت المتوقع للتوصيل

//       // ============================
//       // إنشاء نموذج الطلب
//       // ============================
//       final cashOrder = CashPaymentModel(
//         userId: user.uid,
//         paymentMethod: "COD",
//         paymentStatus: "pending",
//         delivery: cartCubit.deliveryCost,
//         tax: cartCubit.taxValue,
//         discount: cartCubit.discountValue,
//         total: finalTotal,
//         orderNote: cartCubit.orderNote,
//         createdAt: Timestamp.now(),
//         driverId: driverIdValue,
//         driverName: driverName,
//         driverPhone: driverPhone,
//         driverImage: driverImage,
//         branchId: branchIdValue,
//         orderStatus: orderStatusValue,
//         branchName: branchNameValue,
//         branchLat: branchLatValue,
//         branchLng: branchLngValue,
//         estimatedMinutes: estimatedMinutesValue,
//         products: cartCubit.items

// .map(
//               (item) => {
//                 "product_id": item.product.id,
//                 "name": item.product.name,
//                 "price": item.product.price,
//                 "quantity": item.quantity,
//                 "discount": 0.0,
//               },
//             )
//             .toList(),
//       );

//       // ============================
//       // رفع الطلب لقاعدة البيانات
//       // ============================
//       await FirebaseFirestore.instance
//           .collection("orders")
//           .add(cashOrder.toMap())
//           .timeout(const Duration(seconds: 10));

//       if (isClosed) return;

//       emit(CashPaymentSuccess("تم إنشاء الطلب بنجاح"));
//     } on TimeoutException {
//       if (isClosed) return;
//       emit(CashPaymentError("انتهى وقت الاتصال، حاول مرة أخرى"));
//     } catch (e) {
//       if (isClosed) return;
//       emit(CashPaymentError("حدث خطأ أثناء إنشاء الطلب"));
//     }
//   }

//   /// ============================
//   /// إلغاء الطلب قبل القبول
//   /// ============================
//   // void cancelCashOrder() {
//   //   emit(CashPaymentError(
//   //       "تم إلغاء الطلب: الدليفري مشغولين حالياً، سيتم إبلاغك عند توفر سائق"));
//   // }
// }
