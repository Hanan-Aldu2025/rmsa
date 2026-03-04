// lib/featurees/main_screens/change_account/data/repositories/change_account_repository_impl.dart

import 'package:appp/core/error/failure.dart';
import 'package:appp/featurees/main_screens/change_account/data/datasources/change_account_remote_data_source.dart';
import 'package:appp/featurees/main_screens/change_account/domain/entities/role_entity.dart';
import 'package:appp/featurees/main_screens/change_account/domain/repositories/change_account_repository.dart';
import 'package:appp/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

/// تنفيذ ChangeAccountRepository
class ChangeAccountRepositoryImpl implements ChangeAccountRepository {
  final ChangeAccountRemoteDataSource remoteDataSource;

  ChangeAccountRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> getUserRole(String uid) async {
    try {
      final role = await remoteDataSource.getUserRole(uid);
      return right(role);
    } catch (e) {
      return left(FailureServer('Error getting user role: $e'));
    }
  }

  @override
  Future<bool> canAccessRole(String uid, String requestedRole) async {
    final result = await getUserRole(uid);
    return result.fold(
      (failure) => false,
      (actualRole) => actualRole == requestedRole || requestedRole == 'user',
    );
  }

  @override
  List<RoleEntity> getAvailableRoles() {
    return [
      RoleEntity(
        role: UserRole.user,
        title: S.current.userRole,
        subtitle: S.current.userSubtitle,
        icon: Icons.person_pin_rounded,
      ),
      RoleEntity(
        role: UserRole.delivery,
        title: S.current.deliveryRole,
        subtitle: S.current.deliverySubtitle,
        icon: Icons.delivery_dining_rounded,
      ),
      RoleEntity(
        role: UserRole.admin,
        title: S.current.adminRole,
        subtitle: S.current.adminSubtitle,
        icon: Icons.admin_panel_settings_rounded,
      ),
    ];
  }
}
