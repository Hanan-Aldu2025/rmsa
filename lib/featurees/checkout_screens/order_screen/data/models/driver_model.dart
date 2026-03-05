import 'package:cloud_firestore/cloud_firestore.dart';

/// Base class
class Driver {
  final String id;
  final String name;
  final String phone;
  final String imageUrl;
  final double rating;

  Driver({
    required this.id,
    required this.name,
    required this.phone,
    required this.imageUrl,
    required this.rating,
  });
}

/// DriverModel يمتد من Driver
class DriverModel extends Driver {
  final bool isActive;
  final bool isAvailable;
  final bool isOnline;
  final bool isBlocked;
  final bool hasActiveOrder;

  final int totalRatings;
  final int ratingSum;
  final int cancelledOrder;
  final int completedOrder;

  final String vehicleType;
  final String vehicleColor;
  final String vehiclePlate;
  final String deliveryMethod;

  final String branchId;
  final String cityId;
  final String orderId;
  final String email;

  final Timestamp createAt;
  final Timestamp lastActiveAt;
  final Timestamp lastloacationUpdate;

  final GeoPoint lat; // 👈 موقع السائق (GeoPoint)

  DriverModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.imageUrl,
    required super.rating,
    required this.isActive,
    required this.isAvailable,
    required this.isOnline,
    required this.isBlocked,
    required this.hasActiveOrder,
    required this.totalRatings,
    required this.ratingSum,
    required this.cancelledOrder,
    required this.completedOrder,
    required this.vehicleType,
    required this.vehicleColor,
    required this.vehiclePlate,
    required this.deliveryMethod,
    required this.branchId,
    required this.cityId,
    required this.orderId,
    required this.email,
    required this.createAt,
    required this.lastActiveAt,
    required this.lastloacationUpdate,
    required this.lat,
  });

  factory DriverModel.fromMap(Map<String, dynamic> map, String id) {
    return DriverModel(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,

      isActive: map['isActive'] ?? true,
      isAvailable: map['isAvailable'] ?? false,
      isOnline: map['isOnline'] ?? false,
      isBlocked: map['isBlocked'] ?? false,
      hasActiveOrder: map['hasActiveOrder'] ?? false,

      totalRatings: map['totalRatings'] ?? 0,
      ratingSum: map['ratingSum'] ?? 0,
      cancelledOrder: map['cancelledOrder'] ?? 0,
      completedOrder: map['completedOrder'] ?? 0,

      vehicleType: map['vehicleType'] ?? '',
      vehicleColor: map['vehicleColor'] ?? '',
      vehiclePlate: map['vehiclePlate'] ?? '',
      deliveryMethod: map['delivery_method'] ?? '',

      branchId: map['branchId'] ?? '',
      cityId: map['cityId'] ?? '',
      orderId: map['orderId'] ?? '',
      email: map['email'] ?? '',

      createAt: map['createAt'] ?? Timestamp.now(),
      lastActiveAt: map['lastActiveAt'] ?? Timestamp.now(),
      lastloacationUpdate: map['lastloacationUpdate'] ?? Timestamp.now(),

      lat: map['lat'] ?? const GeoPoint(0, 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "imageUrl": imageUrl,
      "rating": rating,

      "isActive": isActive,
      "isAvailable": isAvailable,
      "isOnline": isOnline,
      "isBlocked": isBlocked,
      "hasActiveOrder": hasActiveOrder,

      "totalRatings": totalRatings,
      "ratingSum": ratingSum,
      "cancelledOrder": cancelledOrder,
      "completedOrder": completedOrder,

      "vehicleType": vehicleType,
      "vehicleColor": vehicleColor,
      "vehiclePlate": vehiclePlate,
      "delivery_method": deliveryMethod,

      "branchId": branchId,
      "cityId": cityId,
      "orderId": orderId,
      "email": email,

      "createAt": createAt,
      "lastActiveAt": lastActiveAt,
      "lastloacationUpdate": lastloacationUpdate,

      "lat": lat,
    };
  }
}