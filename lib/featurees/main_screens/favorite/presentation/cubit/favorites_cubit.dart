// lib/featurees/main_screens/favorite/presentation/cubit/favorites_cubit.dart

import 'dart:async';

import 'package:appp/featurees/main_screens/favorite/domain/entities/favorite_entity.dart';
import 'package:appp/featurees/main_screens/favorite/domain/repositories/favorites_repository.dart';
import 'package:appp/featurees/main_screens/favorite/presentation/cubit/favorites_state.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/data_layer.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/domain_layer.dart';
import 'package:appp/featurees/main_screens/home/presentation/views/presentation_layer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';

/// Cubit المسؤول عن منطق صفحة المفضلة
class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository repository;
  final HomeCubit homeCubit;
  late final StreamSubscription<HomeState> homeSub;
  final String uid;
  final TextEditingController searchController = TextEditingController();

  // منع التكرار عند الضغط السريع (Double Tap)
  final Set<String> _processingIds = {};

  FavoritesCubit({
    required this.repository,
    required this.homeCubit,
    required this.uid,
  }) : super(const FavoritesState(quantities: {})) {
    // الاستماع لتغير الفرع في HomeCubit
    homeSub = homeCubit.stream.listen((homeState) {
      if (isClosed) return;
      final selectedBranchId = homeState.selectedBranch?.id ?? '';
      if (selectedBranchId.isNotEmpty) {
        loadFavorites();
      }
    });

    // التحميل الأولي
    loadFavorites();
  }

  @override
  Future<void> close() {
    searchController.dispose();
    homeSub.cancel();
    _processingIds.clear();
    return super.close();
  }

  /// تحميل قائمة المفضلة من Firebase
  Future<void> loadFavorites() async {
    if (isClosed) return;
    emit(state.copyWith(loading: true));

    final selectedBranchId = homeCubit.state.selectedBranch?.id ?? '';
    if (selectedBranchId.isEmpty) {
      if (!isClosed) {
        emit(
          state.copyWith(loading: false, errorMessage: "No branch selected"),
        );
      }
      return;
    }

    final favResult = await repository.fetchFavorites(uid);

    favResult.fold(
      (failure) {
        if (!isClosed) {
          emit(
            state.copyWith(loading: false, errorMessage: failure.errorMessage),
          );
        }
      },
      (favList) async {
        if (favList.isEmpty) {
          emit(
            state.copyWith(
              favorites: [],
              products: [],
              allProducts: [],
              loading: false,
            ),
          );
          return;
        }

        // جلب المنتجات بالتوازي لزيادة السرعة
        try {
          final List<Future<DocumentSnapshot>> tasks = favList.map((fav) {
            return FirebaseFirestore.instance
                .collection('products')
                .doc(fav.productId)
                .get();
          }).toList();

          final List<DocumentSnapshot> snapshots = await Future.wait(tasks);

          // تحويل ProductModel إلى ProductEntity
          List<ProductEntity> products = [];
          for (var snap in snapshots) {
            if (snap.exists) {
              final productModel = ProductModel.fromDoc(snap);
              // فلترة حسب الفرع المختار
              if (productModel.branchIds.contains(selectedBranchId)) {
                products.add(productModel.toEntity());
              }
            }
          }

          if (!isClosed) {
            emit(
              state.copyWith(
                favorites: favList,
                products: products,
                allProducts: products,
                loading: false,
              ),
            );
          }
        } catch (e) {
          if (!isClosed) {
            emit(state.copyWith(loading: false, errorMessage: e.toString()));
          }
        }
      },
    );
  }

  /// تصفير الكميات
  void resetQuantities() {
    if (!isClosed) emit(state.copyWith(quantities: {}));
  }

  /// زيادة كمية منتج
  void increaseQuantity(String productId) {
    if (isClosed) return;

    final newQuantities = Map<String, int>.from(state.quantities);
    final currentQty = newQuantities[productId] ?? 0;

    newQuantities[productId] = currentQty + 1;
    emit(state.copyWith(quantities: newQuantities));
  }

  /// نقص كمية منتج
  void decreaseQuantity(String productId) {
    if (isClosed) return;

    final newQuantities = Map<String, int>.from(state.quantities);
    final currentQty = newQuantities[productId] ?? 0;

    if (currentQty > 0) {
      newQuantities[productId] = currentQty - 1;
      emit(state.copyWith(quantities: newQuantities));
    }
  }

  /// تبديل حالة المفضلة (إضافة/حذف)
  Future<void> toggleFavorite(ProductEntity product) async {
    // منع التكرار
    if (isClosed || _processingIds.contains(product.id)) return;

    _processingIds.add(product.id);

    // الاحتفاظ بالنسخة القديمة للعودة عند الفشل
    final oldFavs = List<FavoriteEntity>.from(state.favorites);
    final oldProds = List<ProductEntity>.from(state.products);

    final existing = oldFavs.firstWhereOrNull((f) => f.productId == product.id);

    // تحديث الواجهة فوراً (Optimistic Update)
    if (existing != null) {
      // حذف محلي
      final newFavs = oldFavs.where((f) => f.productId != product.id).toList();
      final newProds = oldProds.where((p) => p.id != product.id).toList();
      emit(
        state.copyWith(
          favorites: newFavs,
          products: newProds,
          allProducts: newProds,
        ),
      );
    } else {
      // إضافة محلية وهمية
      final temporaryFav = FavoriteEntity(
        id: 'temp_${product.id}',
        productId: product.id,
        addedAt: DateTime.now(),
      );
      emit(
        state.copyWith(
          favorites: [...oldFavs, temporaryFav],
          products: [...oldProds, product],
          allProducts: [...state.allProducts, product],
        ),
      );
    }

    // الاتصال بـ Firebase في الخلفية
    try {
      if (existing != null) {
        await repository.removeFavorite(uid, existing.id);
      } else {
        final result = await repository.addFavorite(uid, product.id);
        result.fold(
          (l) => throw Exception(),
          (r) => loadFavorites(), // إعادة تحميل للحصول على ID حقيقي
        );
      }
    } catch (e) {
      // في حالة الفشل: العودة للحالة القديمة
      if (!isClosed) {
        emit(
          state.copyWith(
            favorites: oldFavs,
            products: oldProds,
            allProducts: oldProds,
          ),
        );
      }
    } finally {
      _processingIds.remove(product.id);
    }
  }

  /// البحث في المفضلة
  void searchFavorites(String query) {
    if (isClosed) return;

    if (query.isEmpty) {
      emit(state.copyWith(products: state.allProducts));
      return;
    }

    final filtered = state.allProducts
        .where(
          (p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.nameAr.contains(query),
        )
        .toList();

    emit(state.copyWith(products: filtered));
  }

  /// مسح البحث
  void clearSearch() {
    searchController.clear();
    searchFavorites("");
  }
}
