// lib/featurees/main_screens/profile/data/repositories/profile_repository_impl.dart

import 'package:appp/core/error/failure.dart';
import 'package:appp/featurees/main_screens/profile/data/datasources/profile_remote_data_source.dart';
import 'package:appp/featurees/main_screens/profile/domain/entities/user_entity.dart';
import 'package:appp/featurees/main_screens/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

/// تنفيذ ProfileRepository - يربط بين الـ Domain والـ Data Source
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<UserEntity> getUserData(String uid) {
    return remoteDataSource.getUserData(uid).map((model) => model.toEntity());
  }

  @override
  Future<Either<Failure, String>> updateProfileImage(
    String imagePath,
    String uid,
  ) async {
    try {
      final imageUrl = await remoteDataSource.uploadImageToImgBB(imagePath);
      await remoteDataSource.updateProfileImage(uid, imageUrl);
      return right(imageUrl);
    } catch (e) {
      return left(FailureServer('Error updating profile image: $e'));
    }
  }
}
