import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entity/order_entity.dart';
import 'driver_model.dart';

class OrderModel extends OrderEntity {
  final String? driverId;
  final int? estimatedMinutes;
  final double tax;

  OrderModel({
    required super.id,
    required super.userId,
    required super.items,
    required super.totalAmount,
    required super.delivery,
    super.discount = 0.0,
    super.pointsDiscount = 0.0,
    super.orderNote,
    this.tax = 0.0,
    required super.paymentMethod,
    required super.paymentStatus,
    required super.orderStatus,
    required super.createdAt,
    required super.updatedAt,
    this.driverId,
    this.estimatedMinutes,
    required super.branchId,
    required super.branchName,
    required super.branchLocation,
    super.userLocation,
    super.estimatedDeliveryTime,
    super.driver,
    super.driverLocation,

    super.acceptedAt,
    super.assignedAt,
    super.cancelledAt,
    super.cancelledBy,
    super.cancelReason,
    super.deliveredAt,
    super.onTheWayAt,
    super.paidAt,
    super.pickedUpAt,
    super.preparingAt,
    super.readyAt,
    super.lastDriverLocationAt,
    super.isArchived,
    super.isDelayed,
    super.isRated,
    super.distanceKm,
    super.driverLat,
    super.driverLng,
    super.driverRoting,
    super.realDeliveryMinutes,
    super.reviewId,
  }) : super();

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    final productsList = map['products'] ?? [];

    final itemsList = (productsList as List<dynamic>)
        .map(
          (i) => OrderItem(
            productId: i['productId']?.toString() ?? '',
            name: i['name']?.toString() ?? '',
            quantity: (i['quantity'] as num?)?.toInt() ?? 0,
            price: (i['price'] as num?)?.toDouble() ?? 0,
            discount: (i['discount'] as num?)?.toDouble() ?? 0,
          ),
        )
        .toList();

    String estimatedDeliveryTime = "N/A";
    if (map['estimatedMinutes'] != null) {
      final minutes = map['estimatedMinutes'] as int;
      final hoursPart = (minutes ~/ 60);
      final minutesPart = (minutes % 60);
      estimatedDeliveryTime = "${hoursPart}h ${minutesPart}m";
    }

    return OrderModel(
      id: id,
      userId: (map['userId'] ?? map['user_id'] ?? '').toString(),
      items: itemsList,
      totalAmount:
          (map['total'] ?? map['total_amount'] as num?)?.toDouble() ?? 0,
      delivery: (map['delivery'] as num?)?.toDouble() ?? 0,
      discount: (map['discount'] as num?)?.toDouble() ?? 0,
      pointsDiscount: (map['points_discount'] as num?)?.toDouble() ?? 0,
      tax: (map['tax'] as num?)?.toDouble() ?? 0,
      paymentMethod: (map['paymentMethod'] ?? map['payment_method'] ?? 'COD')
          .toString(),
      paymentStatus:
          (map['paymentStatus'] ?? map['payment_status'] ?? 'pending')
              .toString(),
      orderStatus:
          ((map['orderStatus'] ?? map['order_state'] ?? '') as String).isEmpty
          ? 'Confirmed'
          : (map['orderStatus'] ?? map['order_state']).toString(),
      createdAt:
          (map['createAt'] ??
                  map['createdAt'] ??
                  map['created_at'] as Timestamp?)
              ?.toDate() ??
          DateTime.now(),
      updatedAt:
          (map['updateAt'] ??
                  map['updatedAt'] ??
                  map['updated_at'] as Timestamp?)
              ?.toDate() ??
          DateTime.now(),
      orderNote: (map['orderNote'] ?? map['order_note'])?.toString(),
      driverId: (map['driverId'] ?? map['driver_id'])?.toString(),
      estimatedMinutes:
          (map['estimatedMinutes'] ?? map['estimated_minutes'] as int?) ?? 0,
      branchId: (map['branchId'] ?? map['branch_id'])?.toString() ?? '',
      branchName: (map['branchName'] ?? 'Unknown Branch').toString(),
      branchLocation: map['branchLocation'] as GeoPoint? ?? GeoPoint(0, 0),
      userLocation: map['userLocation'] as GeoPoint?,
      driverLocation: map['driverLocation']as GeoPoint?,
      estimatedDeliveryTime: estimatedDeliveryTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'products': items
          .map(
            (i) => {
              'productId': i.productId,
              'name': i.name,
              'quantity': i.quantity,
              'price': i.price,
              'discount': i.discount,
            },
          )
          .toList(),
      'total': totalAmount,
      'delivery': delivery,
      'discount': discount,
      'points_discount': pointsDiscount,
      'tax': tax,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      'createAt': Timestamp.fromDate(createdAt),
      'updateAt': Timestamp.fromDate(updatedAt),
      'orderNote': orderNote ?? '',
      'driverId': driverId,
      'estimatedMinutes': estimatedMinutes ?? 0,
      'branchId': branchId,
      'branchName': branchName,
      'branchLocation': branchLocation,
      'userLocation': userLocation,
      'driverLocation':driverLocation,
    };
  }
}
