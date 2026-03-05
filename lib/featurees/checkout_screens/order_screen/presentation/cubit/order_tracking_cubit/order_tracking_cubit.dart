import 'dart:async';
import 'dart:math';
import 'package:appp/featurees/checkout_screens/order_screen/data/models/driver_model.dart';
import 'package:appp/featurees/checkout_screens/order_screen/data/models/order_model.dart';
import 'package:appp/featurees/checkout_screens/order_screen/domain/entity/order_entity.dart';
import 'package:appp/featurees/checkout_screens/order_screen/presentation/cubit/order_tracking_cubit/order_tracking_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderTrackingCubit extends Cubit<OrderTrackingState> {
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _subscription;

  OrderTrackingCubit() : super(OrderTrackingLoading());

  /// ============================
  /// تتبع الطلب الأخير تلقائياً
  /// ============================
  Future<void> startTrackingLastOrder() async {
    emit(OrderTrackingLoading());

    try {
      final query = await FirebaseFirestore.instance
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        emit(OrderTrackingError("لا يوجد طلبات"));
        return;
      }

      final orderId = query.docs.first.id;
      print('تم العثور على آخر طلب: $orderId');
      startTracking(orderId);
    } catch (e) {
      print('خطأ في startTrackingLastOrder: $e');
      emit(OrderTrackingError("خطأ أثناء تحميل آخر طلب: ${e.toString()}"));
    }
  }

  /// ============================
  /// تتبع طلب معين حسب orderId
  /// ============================
  void startTracking(String orderId) {
    _subscription = FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .snapshots()
        .listen(
          (doc) async {
            try {
              if (!doc.exists || doc.data() == null) {
                emit(OrderTrackingError("الطلب غير موجود"));
                return;
              }

              final data = doc.data()!;
              print('بيانات الطلب المستلمة: ${data.keys}');

              final orderModel = OrderModel.fromMap(data, doc.id);
              print('orderStatus: ${orderModel.orderStatus}');

              DriverModel? driver;

              // جلب بيانات السائق إذا موجود
              if (orderModel.driverId != null &&
                  orderModel.driverId!.isNotEmpty) {
                print('جلب بيانات السائق: ${orderModel.driverId}');
                final driverDoc = await FirebaseFirestore.instance
                    .collection('drivers')
                    .doc(orderModel.driverId)
                    .get();

                if (driverDoc.exists && driverDoc.data() != null) {
                  driver = DriverModel.fromMap(driverDoc.data()!, driverDoc.id);
                  print('تم جلب بيانات السائق: ${driver?.name}');
                }
              }

              // ============================
              // حساب ETA بالدقائق حسب المسافة
              // ============================
              int etaMinutes = 0;

              if (driver != null) {
                // الحصول على موقع السائق:
                double driverLat;
                double driverLng;

                if (orderModel.driverLocation != null &&
                    (orderModel.driverLocation!.latitude != 0 ||
                        orderModel.driverLocation!.longitude != 0)) {
                  // استخدام driverLocation من الطلب
                  driverLat = orderModel.driverLocation!.latitude;
                  driverLng = orderModel.driverLocation!.longitude;
                  print(
                    'استخدام driverLocation من الطلب: $driverLat, $driverLng',
                  );
                } else if (driver.lat != null &&
                    (driver.lat.latitude != 0 || driver.lat.longitude != 0)) {
                  // استخدام lat من مستند السائق
                  driverLat = driver.lat.latitude;
                  driverLng = driver.lat.longitude;
                  print('استخدام lat من مستند السائق: $driverLat, $driverLng');
                } else {
                  // لم يتوفر موقع للسائق
                  print('لم يتوفر موقع للسائق');
                  driverLat = 0;
                  driverLng = 0;
                }

                // الحصول على موقع الفرع
                final branchLat = orderModel.branchLocation?.latitude ?? 0;
                final branchLng = orderModel.branchLocation?.longitude ?? 0;
                print("============branch ${orderModel.branchLocation}");

                // الحصول على موقع المستخدم
                final userLat = orderModel.userLocation?.latitude ?? 0;
                final userLng = orderModel.userLocation?.longitude ?? 0;
                print("============***branch ${orderModel.userLocation}");

                // التحقق من وجود الإحداثيات
                if (driverLat == 0 || driverLng == 0) {
                  print("تحذير: إحداثيات السائق غير صالحة أو مفقودة");
                }
                if (branchLat == 0 || branchLng == 0) {
                  print("تحذير: إحداثيات الفرع غير صالحة أو مفقودة");
                }
                if (userLat == 0 || userLng == 0) {
                  print("تحذير: إحداثيات المستخدم غير صالحة أو مفقودة");
                }

                double distance = 0;

                // التحقق من توفر الإحداثيات
                final bool hasDriverLocation = driverLat != 0 || driverLng != 0;
                final bool hasBranchLocation = branchLat != 0 || branchLng != 0;
                final bool hasUserLocation = userLat != 0 || userLng != 0;

                if (orderModel.orderStatus == "preparing") {
                  // حالة "preparing" → المسافة بين السائق والفرع
                  if (hasDriverLocation && hasBranchLocation) {
                    distance = _calculateDistanceKm(
                      driverLat,
                      driverLng,
                      branchLat,
                      branchLng,
                    );
                    print(
                      'المسافة بين السائق والفرع: ${distance.toStringAsFixed(2)} كم',
                    );
                  } else {
                    print(
                      'لا يمكن حساب المسافة: موقع السائق أو الفرع غير متوفر',
                    );
                  }
                } else if (orderModel.orderStatus == "accepted" ||
                    orderModel.orderStatus == "confirmed" ||
                    orderModel.orderStatus == "on_the_way") {
                  // حالة "confirmed" أو "on_the_way" → المسافة بين السائق والمستخدم
                  if (hasDriverLocation && hasUserLocation) {
                    distance = _calculateDistanceKm(
                      driverLat,
                      driverLng,
                      userLat,
                      userLng,
                    );
                    print(
                      'المسافة بين السائق والمستخدم: ${distance.toStringAsFixed(2)} كم',
                    );
                  } else {
                    print(
                      'لا يمكن حساب المسافة: موقع السائق أو المستخدم غير متوفر',
                    );
                  }
                }

                // تحويل المسافة إلى دقائق (متوسط سرعة 40 كم/س)
                if (distance > 0) {
                  etaMinutes = _calculateEstimatedMinutes(distance);
                  print('الوقت المتوقع للتوصيل: $etaMinutes دقيقة');
                } else {
                  etaMinutes = 0;
                  print('الوقت المتوقع للتوصيل: 0 (لعدم توفر الإحداثيات)');
                }
              }

              // تحويل OrderModel إلى OrderEntity
              final orderEntity = OrderEntity(
                id: orderModel.id,
                userId: orderModel.userId,
                items: orderModel.items,
                totalAmount: orderModel.totalAmount,
                delivery: orderModel.delivery,
                discount: orderModel.discount,
                pointsDiscount: orderModel.pointsDiscount,
                tax: orderModel.tax,
                paymentMethod: orderModel.paymentMethod,
                paymentStatus: orderModel.paymentStatus,
                orderStatus: orderModel.orderStatus ?? 'pending',
                createdAt: orderModel.createdAt,
                updatedAt: orderModel.updatedAt,
                orderNote: orderModel.orderNote,
                estimatedDeliveryTime:
                    orderModel.estimatedDeliveryTime ?? 'N/A',
                driver: driver,
                driverLocation: orderModel.driverLocation ?? GeoPoint(0, 0),
                branchId: orderModel.branchId,
                branchName: orderModel.branchName,
                branchLocation: orderModel.branchLocation ?? GeoPoint(0, 0),
                userLocation: orderModel.userLocation ?? GeoPoint(0, 0),
              );

              print(
                'تم إنشاء OrderEntity بنجاح، orderStatus: ${orderEntity.orderStatus}',
              );
              emit(OrderTrackingLoaded(orderEntity, etaMinutes));
            } catch (e) {
              print('خطأ داخل الـ listener: $e');
              emit(
                OrderTrackingError(
                  "خطأ أثناء معالجة البيانات: ${e.toString()}",
                ),
              );
            }
          },
          onError: (error) {
            print('خطأ في الـ stream: $error');
            emit(OrderTrackingError("تعذر تحميل الطلب: ${error.toString()}"));
          },
        );
  }

  /// ============================
  /// تحديث حالة الطلب
  /// ============================
  Future<void> updateOrderStatus({
    required String orderId,
    required String newStatus,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {'orderStatus': newStatus, 'updatedAt': FieldValue.serverTimestamp()},
      );
      print('تم تحديث حالة الطلب إلى: $newStatus');
      print('سيتم تحديث الواجهة تلقائياً عبر الـ stream listener');
    } catch (e) {
      print('خطأ في updateOrderStatus: $e');
      emit(OrderTrackingError("فشل تحديث حالة الطلب: ${e.toString()}"));
    }
  }

  /// ============================
  /// دوال الحساب الداخلية
  /// ============================
  double _toRadians(double degree) => degree * pi / 180;

  double _calculateDistanceKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  int _calculateEstimatedMinutes(double distanceKm) {
    const averageSpeed = 40; // كم/س
    double hours = distanceKm / averageSpeed;
    return (hours * 60).ceil();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
