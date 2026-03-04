// lib/featurees/main_screens/favorite/data/repositories/favorites_repository_impl.dart

import 'package:appp/core/error/failure.dart';
import 'package:appp/featurees/main_screens/favorite/data/datasources/favorites_remote_data_source.dart';
import 'package:appp/featurees/main_screens/favorite/domain/entities/favorite_entity.dart';
import 'package:appp/featurees/main_screens/favorite/domain/repositories/favorites_repository.dart';
import 'package:dartz/dartz.dart';

/// تنفيذ FavoritesRepository - يربط بين الـ Domain والـ Data Source
class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;

  FavoritesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<FavoriteEntity>>> fetchFavorites(
    String uid,
  ) async {
    try {
      final data = await remoteDataSource.getFavorites(uid);
      // تحويل List<FavoriteModel> إلى List<FavoriteEntity>
      return right(data.map((model) => model.toEntity()).toList());
    } catch (e) {
      return left(FailureServer('Error fetching favorites: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addFavorite(
    String uid,
    String productId,
  ) async {
    try {
      await remoteDataSource.addFavorite(uid, productId);
      return right(null);
    } catch (e) {
      return left(FailureServer('Error adding favorite: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String uid, String favId) async {
    try {
      await remoteDataSource.removeFavorite(uid, favId);
      return right(null);
    } catch (e) {
      return left(FailureServer('Error removing favorite: $e'));
    }
  }
}
