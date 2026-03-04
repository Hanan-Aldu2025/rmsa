import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// موديل الفرع - مسؤول عن تحويل البيانات من وإلى Firestore
class BranchModel {
  final String id;
  final String branchId;
  final String name;
  final String nameAr;
  final String address;
  final String addressAr;
  final GeoPoint location;
  final String phone;
  final String status;
  final List<String> categoryIds;
  final String email;
  final String imageUrl;
  final List<String> images;
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

  /// تحويل من DocumentSnapshot إلى Model
  factory BranchModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BranchModel(
      id: doc.id,
      branchId: data['branchId'] ?? '',
      name: data['name'] ?? '',
      nameAr: data['name_ar'] ?? '',
      address: data['address'] ?? '',
      addressAr: data['address_ar'] ?? '',
      location: data['location'] ?? const GeoPoint(0, 0),
      phone: data['phone'] ?? '',
      status: data['status'] ?? 'offline',
      categoryIds: List<String>.from(data['categoryIds'] ?? []),
      email: data['email'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      isActive: data['isActive'] ?? false,
      isBusy: data['isBusy'] ?? false,
      isOpen: data['isOpen'] ?? false,
      lat: (data['lat'] ?? 0.0).toDouble(),
      lng: (data['lng'] ?? 0.0).toDouble(),
      geofenceRadius: (data['geofenceRadius'] ?? 0.0).toDouble(),
      deliveryRadius: (data['deliveryRadius'] ?? 0.0).toDouble(),
      deliveryFree: (data['deliveryFree'] ?? 0.0).toDouble(),
      rating: (data['rating'] ?? 0.0).toDouble(),
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

  /// تحويل من Model إلى Entity
  BranchEntity toEntity() {
    return BranchEntity(
      id: id,
      branchId: branchId,
      name: name,
      nameAr: nameAr,
      address: address,
      addressAr: addressAr,
      lat: lat,
      lng: lng,
      phone: phone,
      status: status,
      categoryIds: categoryIds,
      email: email,
      imageUrl: imageUrl,
      images: images,
      isActive: isActive,
      isBusy: isBusy,
      isOpen: isOpen,
      geofenceRadius: geofenceRadius,
      deliveryRadius: deliveryRadius,
      deliveryFree: deliveryFree,
      averageDeliveryTimeMinutes: averageDeliveryTimeMinutes,
      avgDeliveryTime: avgDeliveryTime,
      avgPreparationTime: avgPreparationTime,
      closeTime: closeTime,
      openTime: openTime,
      workingHours: workingHours,
      rating: rating,
      ratingCount: ratingCount,
      topDrivers: topDrivers,
      totalCancelledOrders: totalCancelledOrders,
      totalCompletedOrders: totalCompletedOrders,
      totalOrdersToday: totalOrdersToday,
      instagramUrl: instagramUrl,
      facebookUrl: facebookUrl,
      tiktokUrl: tiktokUrl,
      whatsAppUrl: whatsAppUrl,
    );
  }

  /// تحويل إلى Map للتخزين في Firestore
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

// lib/data/models/category_model.dart

/// موديل القسم - مسؤول عن تحويل البيانات من وإلى Firestore
class CategoryModel {
  final String id;
  final String name;
  final String nameAr;
  final List<String> branchIds;

  CategoryModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.branchIds,
  });

  /// تحويل من DocumentSnapshot إلى Model
  factory CategoryModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      nameAr: data['name_ar'] ?? '',
      branchIds: List<String>.from(data['branchIds'] ?? []),
    );
  }

  /// تحويل من Model إلى Entity
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      nameAr: nameAr,
      branchIds: branchIds,
    );
  }
}

// lib/data/models/product_model.dart

/// موديل المنتج - مسؤول عن تحويل البيانات من وإلى Firestore
class ProductModel {
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
  final List<ProductSizeModel> sizes;
  final List<ExtraOptionModel> extraOption;

  ProductModel({
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

  /// تحويل من DocumentSnapshot إلى Model
  factory ProductModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      nameAr: data['name_ar'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['ptice'] ?? data['price'] ?? 0).toDouble(),
      isAvailable: data['isAvaliable'] ?? true,
      categoryId: data['categoryId'] ?? '',
      branchIds: List<String>.from(data['branchIds'] ?? []),
      description: data['description'] ?? '',
      descriptionAr: data['description_ar'] ?? '',
      discount: (data['discount'] ?? 0).toDouble(),
      points: (data['points'] ?? 0).toInt(),
      selectedSize: data['selectedSize'] ?? '',
      avaliableSize: List<String>.from(data['avaliableSize'] ?? []),
      sizes:
          (data['sizes'] as List<dynamic>?)
              ?.map((e) => ProductSizeModel.fromMap(e))
              .toList() ??
          [],
      extraOption:
          (data['extraoption'] as List<dynamic>?)
              ?.map((e) => ExtraOptionModel.fromMap(e))
              .toList() ??
          [],
    );
  }

  /// تحويل من Model إلى Entity
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      nameAr: nameAr,
      imageUrl: imageUrl,
      price: price,
      isAvailable: isAvailable,
      categoryId: categoryId,
      branchIds: branchIds,
      description: description,
      descriptionAr: descriptionAr,
      discount: discount,
      points: points,
      selectedSize: selectedSize,
      avaliableSize: avaliableSize,
      sizes: sizes.map((s) => s.toEntity()).toList(),
      extraOption: extraOption.map((e) => e.toEntity()).toList(),
    );
  }

  /// بناء المنتج من snapshot (للمفضلة)
  static ProductModel fromDocSnapshotMap(String id, Map<String, dynamic> snap) {
    return ProductModel(
      id: id,
      name: snap['name'] ?? '',
      nameAr: snap['name_ar'] ?? '',
      imageUrl: snap['imageUrl'] ?? '',
      price: (snap['price'] ?? 0).toDouble(),
      isAvailable: snap['isAvailable'] ?? true,
      categoryId: snap['categoryId'] ?? '',
      branchIds: List<String>.from(snap['branchIds'] ?? []),
      description: snap['description'] ?? '',
      descriptionAr: snap['description_ar'] ?? '',
      discount: (snap['discount'] ?? 0).toDouble(),
      points: (snap['points'] ?? 0).toInt(),
      selectedSize: snap['selectedSize'] ?? '',
      avaliableSize: List<String>.from(snap['avaliableSize'] ?? []),
      sizes:
          (snap['sizes'] as List?)
              ?.map(
                (e) => ProductSizeModel.fromMap(Map<String, dynamic>.from(e)),
              )
              .toList() ??
          [],
      extraOption:
          (snap['extraoption'] as List?)
              ?.map(
                (e) => ExtraOptionModel.fromMap(Map<String, dynamic>.from(e)),
              )
              .toList() ??
          [],
    );
  }

  /// تحويل إلى Map للتخزين في Firestore
  Map<String, dynamic> toSnapshot() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'imageUrl': imageUrl,
      'price': price,
      'isAvailable': isAvailable,
      'categoryId': categoryId,
      'branchIds': branchIds,
      'description': description,
      'description_ar': descriptionAr,
      'discount': discount,
      'points': points,
      'selectedSize': selectedSize,
      'avaliableSize': avaliableSize,
      'sizes': sizes.map((s) => s.toMap()).toList(),
      'extraoption': extraOption.map((e) => e.toMap()).toList(),
    };
  }
}

/// موديل حجم المنتج
class ProductSizeModel {
  final String label;
  final String size;
  final int? sizeOz;
  final double price;

  ProductSizeModel({
    required this.label,
    required this.size,
    this.sizeOz,
    required this.price,
  });

  factory ProductSizeModel.fromMap(Map<String, dynamic> map) {
    return ProductSizeModel(
      label: map['lable'] ?? '',
      size: map['size'] ?? '',
      sizeOz: (map['size_oz'] != null) ? (map['size_oz'] as num).toInt() : null,
      price: (map['price'] ?? 0).toDouble(),
    );
  }

  ProductSizeEntity toEntity() {
    return ProductSizeEntity(
      label: label,
      size: size,
      sizeOz: sizeOz,
      price: price,
    );
  }

  Map<String, dynamic> toMap() {
    return {'lable': label, 'size': size, 'size_oz': sizeOz, 'price': price};
  }
}

/// موديل الخيارات الإضافية
class ExtraOptionModel {
  final String option;
  final double? price;

  ExtraOptionModel({required this.option, required this.price});

  factory ExtraOptionModel.fromMap(Map<String, dynamic> map) {
    return ExtraOptionModel(
      option: map['option'] ?? '',
      price: (map['optionprice'] != null)
          ? (map['optionprice'] as num).toDouble()
          : null,
    );
  }

  ExtraOptionEntity toEntity() {
    return ExtraOptionEntity(option: option, price: price);
  }

  Map<String, dynamic> toMap() {
    return {'option': option, 'optionprice': price};
  }
}

/// مصدر البيانات البعيد - مسؤول عن التواصل المباشر مع Firebase
class HomeRemoteDataSource {
  final FirebaseFirestore firestore;

  HomeRemoteDataSource({FirebaseFirestore? firestoreInstance})
    : firestore = firestoreInstance ?? FirebaseFirestore.instance;

  /// جلب جميع الفروع من Firestore
  Future<List<BranchModel>> getBranches() async {
    final snap = await firestore.collection('branches').get();
    return snap.docs.map((d) => BranchModel.fromDoc(d)).toList();
  }

  /// جلب الأقسام لفرع معين
  Future<List<CategoryModel>> getCategories(String branchId) async {
    final snap = await firestore
        .collection('categories')
        .where('branchIds', arrayContains: branchId)
        .get();
    return snap.docs.map((d) => CategoryModel.fromDoc(d)).toList();
  }

  /// الاستماع للتحديثات المباشرة للمنتجات
  Stream<List<ProductModel>> watchProducts(
    String branchId, {
    String? categoryId,
  }) {
    Query query = firestore
        .collection('products')
        .where('branchIds', arrayContains: branchId)
        .where('isAvaliable', isEqualTo: true);

    if (categoryId != null && categoryId != 'all') {
      query = query.where('categoryId', isEqualTo: categoryId);
    }

    return query.snapshots().map(
      (snap) => snap.docs.map((d) => ProductModel.fromDoc(d)).toList(),
    );
  }

  /// البحث في المنتجات
  Future<List<ProductModel>> searchProducts(
    String branchId,
    String queryText,
  ) async {
    final snap = await firestore
        .collection('products')
        .where('branchIds', arrayContains: branchId)
        .where('isAvaliable', isEqualTo: true)
        .get();

    final all = snap.docs.map((d) => ProductModel.fromDoc(d)).toList();
    final lowerQuery = queryText.toLowerCase();

    return all.where((p) {
      final matchEn = p.name.toLowerCase().contains(lowerQuery);
      final matchAr = p.nameAr.toLowerCase().contains(lowerQuery);
      return matchEn || matchAr;
    }).toList();
  }
}

// lib/data/repositories/home_repository_impl.dart

/// تنفيذ HomeRepository - يربط بين الـ Domain والـ Data Source
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BranchEntity>> fetchBranches() async {
    final models = await remoteDataSource.getBranches();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<CategoryEntity>> fetchCategoriesForBranch(String branchId) async {
    final models = await remoteDataSource.getCategories(branchId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Stream<List<ProductEntity>> watchProducts({
    required String branchId,
    String? categoryId,
  }) {
    return remoteDataSource
        .watchProducts(branchId, categoryId: categoryId)
        .map((models) => models.map((model) => model.toEntity()).toList());
  }

  @override
  Future<List<ProductEntity>> searchProducts({
    required String branchId,
    required String queryText,
  }) async {
    final models = await remoteDataSource.searchProducts(branchId, queryText);
    return models.map((model) => model.toEntity()).toList();
  }
}
