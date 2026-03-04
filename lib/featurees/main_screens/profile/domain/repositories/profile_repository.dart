// lib/featurees/main_screens/profile/domain/repositories/profile_repository.dart

import 'package:appp/core/error/failure.dart';
import 'package:appp/featurees/main_screens/profile/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

/// واجهة Profile Repository - تحدد العقود التي يجب تنفيذها في طبقة البيانات
abstract class ProfileRepository {
  /// جلب بيانات المستخدم
  Stream<UserEntity> getUserData(String uid);

  /// تحديث صورة الملف الشخصي
  Future<Either<Failure, String>> updateProfileImage(
    String imagePath,
    String uid,
  );
}
