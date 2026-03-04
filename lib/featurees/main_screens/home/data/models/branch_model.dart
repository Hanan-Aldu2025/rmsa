import 'package:cloud_firestore/cloud_firestore.dart';

class BranchModel {
  final String id;
  final String branchId; // مضاف
  final String name; // الاسم بالإنجليزية
  final String nameAr; // الاسم بالعربية (مضاف)
  final String address; // العنوان بالإنجليزية
  final String addressAr; // العنوان بالعربية (مضاف)
  final GeoPoint location;
  final String phone;
  final String status;
  final List<String> categoryIds;
  final String email;
  final String imageUrl; // الصورة الرئيسية
  final List<String> images; // مصفوفة الصور (مضاف)
  final bool isActive;
  final bool isBusy;
  final bool isOpen;

  // الموقع والمسافات
  final double lat;
  final double lng;
  final double geofenceRadius;
  final double deliveryRadius;
  final double deliveryFree;

  // التوقيت والعمليات
  final int averageDeliveryTimeMinutes;
  final int avgDeliveryTime;
  final int avgPreparationTime;
  final String closeTime;
  final String openTime;
  final Map<String, dynamic> workingHours;

  // الإحصائيات والتقييم
  final double rating;
  final int ratingCount;
  final Timestamp? createdAt;
  final Timestamp? lastUpdated;
  final List<String> topDrivers;
  final int totalCancelledOrders;
  final int totalCompletedOrders;
  final int totalOrdersToday;

  // روابط التواصل الاجتماعي
  final String instagramUrl;
  final String facebookUrl;
  final String tiktokUrl;
  final String whatsAppUrl;

  BranchModel({
    required this.id,
    required this.branchId,
    required this.name,
    required this.nameAr,
    required this.address,
    required this.addressAr,
    required this.location,
    required this.phone,
    required this.status,
    required this.categoryIds,
    required this.email,
    required this.imageUrl,
    required this.images,
    required this.isActive,
    required this.isBusy,
    required this.isOpen,
    required this.lat,
    required this.lng,
    required this.geofenceRadius,
    required this.deliveryRadius,
    required this.deliveryFree,
    required this.averageDeliveryTimeMinutes,
    required this.avgDeliveryTime,
    required this.avgPreparationTime,
    required this.closeTime,
    required this.openTime,
    required this.workingHours,
    required this.rating,
    required this.ratingCount,
    this.createdAt,
    this.lastUpdated,
    required this.topDrivers,
    required this.totalCancelledOrders,
    required this.totalCompletedOrders,
    required this.totalOrdersToday,
    required this.instagramUrl,
    required this.facebookUrl,
    required this.tiktokUrl,
    required this.whatsAppUrl,
  });

  factory BranchModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return BranchModel(
      id: doc.id,
      branchId: data['branchId'] ?? '',
      name: data['name'] ?? '',
      nameAr: data['name_ar'] ?? '', // مطابقة للفيرستور
      address: data['address'] ?? '',
      addressAr: data['address_ar'] ?? '', // مطابقة للفيرستور
      location: data['location'] ?? const GeoPoint(0, 0),
      phone: data['phone'] ?? '',
      status: data['status'] ?? 'offline',
      categoryIds: List<String>.from(data['categoryIds'] ?? []),
      email: data['email'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      images: List<String>.from(data['images'] ?? []), // تحويل المصفوفة
      isActive: data['isActive'] ?? false,
      isBusy: data['isBusy'] ?? false,
      isOpen: data['isOpen'] ?? false,

      // الأرقام (Double)
      lat: (data['lat'] ?? 0.0).toDouble(),
      lng: (data['lng'] ?? 0.0).toDouble(),
      geofenceRadius: (data['geofenceRadius'] ?? 0.0).toDouble(),
      deliveryRadius: (data['deliveryRadius'] ?? 0.0).toDouble(),
      deliveryFree: (data['deliveryFree'] ?? 0.0).toDouble(),
      rating: (data['rating'] ?? 0.0).toDouble(),

      // الأرقام (Int)
      ratingCount: data['ratingCount'] ?? 0,
      averageDeliveryTimeMinutes: data['averageDeliveryTimeMinutes'] ?? 0,
      avgDeliveryTime: data['avgDeliveryTime'] ?? 0,
      avgPreparationTime: data['avgPreparationTime'] ?? 0,
      totalCancelledOrders: data['totalCancelledOrders'] ?? 0,
      totalCompletedOrders: data['totalCompletedOrders'] ?? 0,
      totalOrdersToday: data['totalOrdersToday'] ?? 0,

      instagramUrl: data['instagramUrl'] ?? '',
      facebookUrl: data['facebookUrl'] ?? '',
      tiktokUrl: data['tiktokUrl'] ?? '',
      whatsAppUrl: data['whatsAppUrl'] ?? '',

      closeTime: data['closeTime'] ?? '',
      openTime: data['openTime'] ?? '',
      workingHours: data['workingHours'] ?? {},

      createdAt: data['createdAt'] as Timestamp?,
      lastUpdated: data['lastUpdated'] as Timestamp?,
      topDrivers: List<String>.from(data['topDrivers'] ?? []),
    );
  }

  // دالة مساعدة للحصول على الاسم حسب اللغة
  String getName(String langCode) => langCode == 'ar' ? nameAr : name;

  // دالة مساعدة للحصول على العنوان حسب اللغة
  String getAddress(String langCode) => langCode == 'ar' ? addressAr : address;

  Map<String, dynamic> toMap() {
    return {
      'branchId': branchId,
      'name': name,
      'name_ar': nameAr,
      'address': address,
      'address_ar': addressAr,
      'location': location,
      'phone': phone,
      'status': status,
      'categoryIds': categoryIds,
      'email': email,
      'imageUrl': imageUrl,
      'images': images,
      'isActive': isActive,
      'isBusy': isBusy,
      'isOpen': isOpen,
      'lat': lat,
      'lng': lng,
      'geofenceRadius': geofenceRadius,
      'deliveryRadius': deliveryRadius,
      'deliveryFree': deliveryFree,
      'averageDeliveryTimeMinutes': averageDeliveryTimeMinutes,
      'avgDeliveryTime': avgDeliveryTime,
      'avgPreparationTime': avgPreparationTime,
      'closeTime': closeTime,
      'openTime': openTime,
      'workingHours': workingHours,
      'rating': rating,
      'ratingCount': ratingCount,
      'createdAt': createdAt,
      'lastUpdated': lastUpdated,
      'topDrivers': topDrivers,
      'totalCancelledOrders': totalCancelledOrders,
      'totalCompletedOrders': totalCompletedOrders,
      'totalOrdersToday': totalOrdersToday,
      'instagramUrl': instagramUrl,
      'facebookUrl': facebookUrl,
      'tiktokUrl': tiktokUrl,
      'whatsAppUrl': whatsAppUrl,
    };
  }
}
