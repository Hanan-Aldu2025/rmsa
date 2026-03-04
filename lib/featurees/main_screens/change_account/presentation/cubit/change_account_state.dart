import 'package:appp/featurees/main_screens/change_account/domain/entities/role_entity.dart';
import 'package:equatable/equatable.dart';

/// حالات صفحة تبديل الحساب
class ChangeAccountState extends Equatable {
  final UserRole selectedRole;
  final bool isLoading;
  final String? errorMessage;

  const ChangeAccountState({
    this.selectedRole = UserRole.user,
    this.isLoading = false,
    this.errorMessage,
  });

  /// إنشاء نسخة جديدة مع تحديث بعض الحقول
  ChangeAccountState copyWith({
    UserRole? selectedRole,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ChangeAccountState(
      selectedRole: selectedRole ?? this.selectedRole,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [selectedRole, isLoading, errorMessage];
}
