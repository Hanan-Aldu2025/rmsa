// order_entity.dart
import 'package:appp/featurees/checkout_screens/order_screen/data/models/driver_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final List<OrderItem> items;

  final double totalAmount;
  final double delivery;
  final double discount;
  final double pointsDiscount;
  final double tax;

  final String paymentMethod;
  final String paymentStatus;
  final String? orderStatus;

  final DateTime createdAt;
  final DateTime updatedAt;

  // ===== تواريخ إضافية متطابقة مع DB =====
  final DateTime? acceptedAt;
  final DateTime? assignedAt;
  final DateTime? cancelledAt;
  final String? cancelledBy;
  final String? cancelReason;
  final DateTime? deliveredAt;
  final DateTime? onTheWayAt;
  final DateTime? paidAt;
  final DateTime? pickedUpAt;
  final DateTime? preparingAt;
  final DateTime? readyAt;
  final DateTime? lastDriverLocationAt;

  // ===== حالة إضافية =====
  final bool? isArchived;
  final bool? isDelayed;
  final bool? isRated;

  final int? distanceKm;
  final int? driverLat;
  final int? driverLng;
  final int? driverRoting;
  final int? realDeliveryMinutes;
  final String? reviewId;

  // ===== الحقول الجديدة للفرع =====
  final String branchId;
  final String branchName;
  final GeoPoint branchLocation;

  // ===== موقع المستخدم =====
  final GeoPoint? userLocation;

  // ===== موقع السائق =====
  final GeoPoint? driverLocation;

  final DriverModel? driver;
  final String estimatedDeliveryTime;
  final String? orderNote;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.delivery,
    this.discount = 0,
    this.pointsDiscount = 0,
    this.tax = 0.0,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.createdAt,
    required this.updatedAt,
    this.orderNote,
    this.driver,
    required this.branchId,
    required this.branchName,
    required this.branchLocation,
    this.userLocation,
    this.estimatedDeliveryTime = "N/A",
    this.acceptedAt,
    this.assignedAt,
    this.cancelledAt,
    this.cancelledBy,
    this.cancelReason,
    this.deliveredAt,
    this.onTheWayAt,
    this.paidAt,
    this.pickedUpAt,
    this.preparingAt,
    this.readyAt,
    this.lastDriverLocationAt,
    this.isArchived,
    this.isDelayed,
    this.isRated,
    this.distanceKm,
    this.driverLat,
    this.driverLng,
    this.driverRoting,
    this.realDeliveryMinutes,
    this.reviewId,
    this.driverLocation,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        items,
        totalAmount,
        delivery,
        discount,
        pointsDiscount,
        tax,
        paymentMethod,
        paymentStatus,
        orderStatus,
        createdAt,
        updatedAt,
        acceptedAt,
        assignedAt,
        cancelledAt,
        cancelledBy,
        cancelReason,
        deliveredAt,
        onTheWayAt,
        paidAt,
        pickedUpAt,
        preparingAt,
        readyAt,
        lastDriverLocationAt,
        isArchived,
        isDelayed,
        isRated,
        distanceKm,
        driverLat,
        driverLng,
        driverRoting,
        realDeliveryMinutes,
        reviewId,
        branchId,
        branchName,
        branchLocation,
        userLocation,
        driverLocation,
        driver,
        estimatedDeliveryTime,
        orderNote,
      ];
}

class OrderItem extends Equatable {
  final String productId;
  final String name;
  final int quantity;
  final double price;
  final double discount;

  const OrderItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    this.discount = 0,
  });

  @override
  List<Object?> get props => [productId, name, quantity, price, discount];
}