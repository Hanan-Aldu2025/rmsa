// lib/featurees/main_screens/personal/presentation/cubit/personal_cubit.dart

import 'package:appp/featurees/main_screens/personal/domain/repositories/personal_repository.dart';
import 'package:appp/featurees/main_screens/personal/presentation/cubit/personal_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// المسؤول عن منطق صفحة البيانات الشخصية
/// Personal Cubit - Manages the logic of the personal info page
class PersonalCubit extends Cubit<PersonalState> {
  final PersonalRepository repository;
  final Map<String, dynamic> initialData;
  final String uid; // معرف المستخدم الفريد / User unique ID

  // متحكمات حقول الإدخال / Input controllers
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController newPasswordController;
  late final TextEditingController oldPasswordController;

  PersonalCubit({
    required this.repository,
    required this.initialData,
    required this.uid, // استقبال uid / Receiving uid
  }) : super(PersonalInitial()) {
    _initializeControllers();
    emit(PersonalDisplay(isEditing: false, initialData: initialData));
  }

  /// تهيئة المتحكمات بالقيم الأولية
  /// Initialize controllers with initial data
  void _initializeControllers() {
    nameController = TextEditingController(
      text: initialData['user_name'] ?? '',
    );
    phoneController = TextEditingController(text: initialData['phone'] ?? '');
    emailController = TextEditingController(
      text: initialData['user_email'] ?? '',
    );
    newPasswordController = TextEditingController();
    oldPasswordController = TextEditingController();
  }

  /// تبديل وضع التعديل (تعديل/عرض)
  /// Toggle editing mode
  void toggleEditing() {
    if (state is PersonalDisplay) {
      final current = state as PersonalDisplay;
      emit(
        PersonalDisplay(
          isEditing: !current.isEditing,
          initialData: initialData,
        ),
      );
    }
  }

  /// إلغاء التعديل والعودة للقيم الأصلية
  /// Cancel editing and revert to original values
  void cancelEditing() {
    nameController.text = initialData['user_name'] ?? '';
    phoneController.text = initialData['phone'] ?? '';
    emailController.text = initialData['user_email'] ?? '';
    newPasswordController.clear();
    oldPasswordController.clear();

    emit(PersonalDisplay(isEditing: false, initialData: initialData));
  }

  /// تحديث الملف الشخصي (يتطلب كلمة المرور القديمة)
  /// Update personal profile (requires old password)
  Future<void> updateProfile() async {
    final currentState = state;
    if (currentState is! PersonalDisplay) return;

    // التحقق من إدخال كلمة المرور القديمة / Validate old password
    if (oldPasswordController.text.isEmpty) {
      emit(PersonalUpdateFailure(errorMessage: 'old_password_required'));
      // إعادة الحالة السابقة بعد لحظة / Return to previous state after a moment
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!isClosed) {
          emit(PersonalDisplay(isEditing: true, initialData: initialData));
        }
      });
      return;
    }

    emit(PersonalLoading());

    try {
      final result = await repository.updatePersonalProfile(
        uid: uid, // تمرير uid إلى الـ repository / Passing uid to repository
        name: nameController.text,
        phone: phoneController.text,
        email: emailController.text,
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
      );

      result.fold(
        (failure) =>
            emit(PersonalUpdateFailure(errorMessage: failure.errorMessage)),
        (_) => emit(PersonalUpdateSuccess()),
      );
    } catch (e) {
      emit(PersonalUpdateFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    // التخلص من المتحكمات لتجنب تسرب الذاكرة / Dispose controllers
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    newPasswordController.dispose();
    oldPasswordController.dispose();
    return super.close();
  }
}
