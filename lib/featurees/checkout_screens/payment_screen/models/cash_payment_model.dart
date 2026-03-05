

import 'package:cloud_firestore/cloud_firestore.dart';

class CashPaymentModel {
  final String userId;
  final String paymentMethod;
  final String paymentStatus;
  final double delivery;
  final double tax;
  final double discount;
  final double total;
  final String orderNote;
  final Timestamp createdAt;
  final String driverId;
  final String driverName;       // أضفنا اسم السائق
  final String driverPhone;      // أضفنا رقم الهاتف
  final String driverImage;      // أضفنا صورة السائق
  final String branchId;
  final String orderStatus;
  final String branchName;
  final double branchLat;
  final double branchLng;
  final int estimatedMinutes;
  final List<Map<String, dynamic>> products;

  CashPaymentModel({
    required this.userId,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.delivery,
    required this.tax,
    required this.discount,
    required this.total,
    required this.orderNote,
    required this.createdAt,
    required this.driverId,
    required this.driverName,       // تأكد من تمرير اسم السائق
    required this.driverPhone,      // تأكد من تمرير رقم الهاتف
    required this.driverImage,      // تأكد من تمرير صورة السائق
    required this.branchId,
    required this.orderStatus,

    required this.branchName,
    required this.branchLat,
    required this.branchLng,
    required this.estimatedMinutes,
    required this.products,
  });

  // تحويل البيانات من Map إلى CashPaymentModel
  factory CashPaymentModel.fromMap(Map<String, dynamic> map) {
    return CashPaymentModel(
      userId: map['userId'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      paymentStatus: map['paymentStatus'] ?? '',
      delivery: (map['delivery'] as num?)?.toDouble() ?? 0.0,
      tax: (map['tax'] as num?)?.toDouble() ?? 0.0,
      discount: (map['discount'] as num?)?.toDouble() ?? 0.0,
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
      orderNote: map['orderNote'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
      driverId: map['driverId'] ?? '',
      driverName: map['driverName'] ?? '',       // تأكد من إضافته
      driverPhone: map['driverPhone'] ?? '',     // تأكد من إضافته
      driverImage: map['driverImage'] ?? '',     // تأكد من إضافته
      branchId: map['branchId'] ?? '',
      orderStatus: map['orderStatus'] ?? '',
      branchName: map['branchName'] ?? '',
      branchLat: (map['branchLat'] as num?)?.toDouble() ?? 0.0,
      branchLng: (map['branchLng'] as num?)?.toDouble() ?? 0.0,
      estimatedMinutes: map['estimatedMinutes'] ?? 30,
      products: List<Map<String, dynamic>>.from(map['products'] ?? []),
    );
  }

  // تحويل CashPaymentModel إلى Map لتخزينه في Firestore
  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "paymentMethod": paymentMethod,
      "paymentStatus": paymentStatus,
      "delivery": delivery,
      "tax": tax,
      "discount": discount,
      "total": total,
      "orderNote": orderNote,
      "createdAt": createdAt,
      "driverId": driverId,
      "driverName": driverName,       // تأكد من إضافته
      "driverPhone": driverPhone,     // تأكد من إضافته
      "driverImage": driverImage,     // تأكد من إضافته
      "branchId": branchId,
      "orderStatus": orderStatus,
      "branchName": branchName,
      "branchLat": branchLat,
      "branchLng": branchLng,
      "estimatedMinutes": estimatedMinutes,
      "products": products,
    };
  }
}