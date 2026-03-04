// lib/featurees/main_screens/favorite/domain/repositories/favorites_repository.dart

import 'package:appp/core/error/failure.dart';
import 'package:appp/featurees/main_screens/favorite/domain/entities/favorite_entity.dart';
import 'package:dartz/dartz.dart';

/// واجهة Favorites Repository - تحدد العقود التي يجب تنفيذها في طبقة البيانات
abstract class FavoritesRepository {
  /// جلب قائمة المفضلة للمستخدم
  Future<Either<Failure, List<FavoriteEntity>>> fetchFavorites(String uid);

  /// إضافة منتج إلى المفضلة
  Future<Either<Failure, void>> addFavorite(String uid, String productId);

  /// حذف منتج من المفضلة
  Future<Either<Failure, void>> removeFavorite(String uid, String favId);
}
