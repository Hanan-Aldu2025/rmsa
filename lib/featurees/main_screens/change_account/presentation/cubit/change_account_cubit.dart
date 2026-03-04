// lib/featurees/main_screens/change_account/presentation/cubit/change_account_cubit.dart

import 'package:appp/featurees/main_screens/change_account/domain/entities/role_entity.dart';
import 'package:appp/featurees/main_screens/change_account/domain/repositories/change_account_repository.dart';
import 'package:appp/featurees/main_screens/change_account/presentation/cubit/change_account_state.dart';
import 'package:appp/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit المسؤول عن منطق صفحة تبديل الحساب
class ChangeAccountCubit extends Cubit<ChangeAccountState> {
  final ChangeAccountRepository repository;
  final List<RoleEntity> roles;

  ChangeAccountCubit({required this.repository})
    : roles = repository.getAvailableRoles(),
      super(const ChangeAccountState());

  /// اختيار دور معين
  void selectRole(UserRole role) {
    emit(state.copyWith(selectedRole: role, errorMessage: null));
  }

  /// تأكيد التبديل والانتقال للصفحة المناسبة
  Future<void> confirmSwitch(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // التحقق من صلاحية الوصول
      final canAccess = await repository.canAccessRole(
        uid,
        state.selectedRole.name,
      );

      if (!canAccess) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: S.of(context).accessDenied,
          ),
        );
        return;
      }

      // الانتقال إلى الصفحة المناسبة
      switch (state.selectedRole) {
        case UserRole.admin:
          // Navigator.pushReplacementNamed(context, AppRoutes.adminHome);
          break;
        case UserRole.delivery:
          // Navigator.pushReplacementNamed(context, AppRoutes.deliveryHome);
          break;
        case UserRole.user:
          Navigator.pop(context);
          break;
      }

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: "${S.of(context).errorPrefix}$e",
        ),
      );
    }
  }
}
