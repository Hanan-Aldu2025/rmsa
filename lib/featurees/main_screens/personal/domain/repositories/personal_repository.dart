// lib/featurees/main_screens/personal/domain/repositories/personal_repository.dart

import 'package:dartz/dartz.dart';
import 'package:appp/core/error/failure.dart';

/// واجهة الـ Repository الخاصة بالصفحة الشخصية
/// Personal Repository Interface
abstract class PersonalRepository {
  /// تحديث البيانات الشخصية (يتطلب uid)
  /// Update personal profile (requires uid)
  Future<Either<Failure, void>> updatePersonalProfile({
    required String uid,
    required String name,
    required String phone,
    required String email,
    required String oldPassword,
    required String newPassword,
  });
}
