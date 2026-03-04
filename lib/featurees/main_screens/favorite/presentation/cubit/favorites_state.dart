// lib/featurees/main_screens/favorite/presentation/cubit/favorites_state.dart

import 'package:appp/featurees/main_screens/favorite/domain/entities/favorite_entity.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:equatable/equatable.dart';

/// حالة المفضلة - تحتوي على جميع بيانات الصفحة
class FavoritesState extends Equatable {
  final List<FavoriteEntity> favorites; // قائمة عناصر المفضلة
  final List<ProductEntity> products; // المنتجات المعروضة (بعد الفلترة)
  final List<ProductEntity> allProducts; // جميع المنتجات (نسخة كاملة)
  final bool loading; // حالة التحميل
  final String? errorMessage; // رسالة الخطأ
  final Map<String, int> quantities; // كميات المنتجات

  const FavoritesState({
    this.favorites = const [],
    this.products = const [],
    this.allProducts = const [],
    this.loading = false,
    this.errorMessage,
    this.quantities = const {},
  });

  /// إنشاء نسخة جديدة مع تحديث بعض الحقول
  FavoritesState copyWith({
    List<FavoriteEntity>? favorites,
    List<ProductEntity>? products,
    List<ProductEntity>? allProducts,
    bool? loading,
    String? errorMessage,
    Map<String, int>? quantities,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      products: products ?? this.products,
      allProducts: allProducts ?? this.allProducts,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      quantities: quantities ?? this.quantities,
    );
  }

  @override
  List<Object?> get props => [
    favorites,
    products,
    allProducts,
    loading,
    errorMessage,
    quantities,
  ];
}
