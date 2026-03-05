/// كيان الفرع - يمثل البيانات الأساسية للفرع في طبقة التطبيق
/// يتم استخدام هذا الكيان في الـ Cubit والواجهات
class BranchEntity {
  final String id;
  final String branchId;
  final String name;
  final String nameAr;
  final String address;
  final String addressAr;
  final double lat;
  final double lng;
  final String phone;
  final String status;
  final List<String> categoryIds;
  final String email;
  final String imageUrl;
  final List<String> images;
  final bool isActive;
  final bool isBusy;
  final bool isOpen;
  final double geofenceRadius;
  final double deliveryRadius;
  final double deliveryFree;
  final int averageDeliveryTimeMinutes;
  final int avgDeliveryTime;
  final int avgPreparationTime;
  final String closeTime;
  final String openTime;
  final Map<String, dynamic> workingHours;
  final double rating;
  final int ratingCount;
  final List<String> topDrivers;
  final int totalCancelledOrders;
  final int totalCompletedOrders;
  final int totalOrdersToday;
  final String instagramUrl;
  final String facebookUrl;
  final String tiktokUrl;
  final String whatsAppUrl;

  BranchEntity({
    required this.id,
    required this.branchId,
    required this.name,
    required this.nameAr,
    required this.address,
    required this.addressAr,
    required this.lat,
    required this.lng,
    required this.phone,
    required this.status,
    required this.categoryIds,
    required this.email,
    required this.imageUrl,
    required this.images,
    required this.isActive,
    required this.isBusy,
    required this.isOpen,
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
    required this.topDrivers,
    required this.totalCancelledOrders,
    required this.totalCompletedOrders,
    required this.totalOrdersToday,
    required this.instagramUrl,
    required this.facebookUrl,
    required this.tiktokUrl,
    required this.whatsAppUrl,
  });

  /// دالة مساعدة للحصول على الاسم حسب اللغة
  String getName(String langCode) => langCode == 'ar' ? nameAr : name;

  /// دالة مساعدة للحصول على العنوان حسب اللغة
  String getAddress(String langCode) => langCode == 'ar' ? addressAr : address;
}

// lib/domain/entities/category_entity.dart

/// كيان القسم - يمثل البيانات الأساسية للقسم في طبقة التطبيق
class CategoryEntity {
  final String id;
  final String name;
  final String nameAr;
  final List<String> branchIds;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.branchIds,
  });
}

// lib/domain/entities/product_entity.dart

/// كيان المنتج - يمثل البيانات الأساسية للمنتج في طبقة التطبيق
class ProductEntity {
  final String id;
  final String name;
  final String nameAr;
  final String imageUrl;
  final double price;
  final bool isAvailable;
  final String categoryId;
  final List<String> branchIds;
  final String description;
  final String descriptionAr;
  final double discount;
  final int points;
  final String selectedSize;
  final List<String> avaliableSize;
  final List<ProductSizeEntity> sizes;
  final List<ExtraOptionEntity> extraOption;

  ProductEntity({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.imageUrl,
    required this.price,
    required this.isAvailable,
    required this.categoryId,
    required this.branchIds,
    required this.description,
    required this.descriptionAr,
    required this.discount,
    required this.points,
    required this.selectedSize,
    required this.avaliableSize,
    required this.sizes,
    required this.extraOption,
  });

  /// نسخ مع تعديل بعض الحقول
  ProductEntity copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? imageUrl,
    double? price,
    bool? isAvailable,
    String? categoryId,
    List<String>? branchIds,
    String? description,
    String? descriptionAr,
    double? discount,
    int? points,
    String? selectedSize,
    List<String>? avaliableSize,
    List<ProductSizeEntity>? sizes,
    List<ExtraOptionEntity>? extraOption,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      isAvailable: isAvailable ?? this.isAvailable,
      categoryId: categoryId ?? this.categoryId,
      branchIds: branchIds ?? this.branchIds,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      discount: discount ?? this.discount,
      points: points ?? this.points,
      selectedSize: selectedSize ?? this.selectedSize,
      avaliableSize: avaliableSize ?? this.avaliableSize,
      sizes: sizes ?? this.sizes,
      extraOption: extraOption ?? this.extraOption,
    );
  }
}

/// كيان حجم المنتج
class ProductSizeEntity {
  final String label;
  final String size;
  final int? sizeOz;
  final double price;

  ProductSizeEntity({
    required this.label,
    required this.size,
    this.sizeOz,
    required this.price,
  });
}

/// كيان الخيارات الإضافية
class ExtraOptionEntity {
  final String option;
  final double? price;

  ExtraOptionEntity({required this.option, required this.price});
}

/// واجهة Home Repository - تحدد العقود التي يجب تنفيذها في طبقة البيانات
abstract class HomeRepository {
  /// جلب جميع الفروع
  Future<List<BranchEntity>> fetchBranches();

  /// جلب الأقسام لفرع معين
  Future<List<CategoryEntity>> fetchCategoriesForBranch(String branchId);

  /// الاستماع للتحديثات المباشرة للمنتجات
  Stream<List<ProductEntity>> watchProducts({
    required String branchId,
    String? categoryId,
  });

  /// البحث في المنتجات
  Future<List<ProductEntity>> searchProducts({
    required String branchId,
    required String queryText,
  });
}
