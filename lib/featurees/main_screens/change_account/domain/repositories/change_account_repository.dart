// lib/featurees/main_screens/change_account/domain/repositories/change_account_repository.dart

import 'package:appp/core/error/failure.dart';
import 'package:appp/featurees/main_screens/change_account/domain/entities/role_entity.dart';
import 'package:dartz/dartz.dart';

/// واجهة Change Account Repository - تحدد العقود التي يجب تنفيذها
abstract class ChangeAccountRepository {
  /// جلب دور المستخدم من قاعدة البيانات
  Future<Either<Failure, String>> getUserRole(String uid);

  /// التحقق من صلاحية الوصول للدور المطلوب
  Future<bool> canAccessRole(String uid, String requestedRole);

  /// الحصول على قائمة الأدوار المتاحة
  List<RoleEntity> getAvailableRoles();
}
