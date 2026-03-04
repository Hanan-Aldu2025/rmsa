// lib/featurees/main_screens/profile/presentation/cubit/profile_cubit.dart

import 'dart:async';

import 'package:appp/featurees/main_screens/profile/domain/entities/user_entity.dart';
import 'package:appp/featurees/main_screens/profile/domain/repositories/profile_repository.dart';
import 'package:appp/featurees/main_screens/profile/presentation/cubit/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cubit المسؤول عن منطق صفحة الملف الشخصي

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;
  final String? uid;
  final bool isGuest;
  StreamSubscription? _userSubscription;

  ProfileCubit({required this.repository, this.uid, required this.isGuest})
    : super(ProfileInitial()) {
    if (!isGuest && uid != null) {
      _listenToUserData();
    } else {
      // حالة الزائر: نرسل ProfileLoaded بمستخدم افتراضي
      emit(
        ProfileLoaded(
          user: UserEntity(uid: '', name: 'زائر', email: '', profileImage: ''),
          isGuest: true,
        ),
      );
    }
  }

  void _listenToUserData() {
    emit(ProfileLoading());
    _userSubscription = repository
        .getUserData(uid!)
        .listen(
          (user) {
            if (!isClosed) {
              emit(ProfileLoaded(user: user, isGuest: false));
            }
          },
          onError: (error) {
            if (!isClosed) {
              emit(ProfileFailure(errorMessage: error.toString()));
            }
          },
        );
  }

  Future<void> updateProfileImage() async {
    if (isGuest || uid == null) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      emit(ProfileLoading());
      try {
        final result = await repository.updateProfileImage(
          pickedFile.path,
          uid!,
        );
        result.fold(
          (failure) => emit(ProfileFailure(errorMessage: failure.errorMessage)),
          (imageUrl) => emit(ProfileSuccess(message: "تم تحديث الصورة بنجاح")),
        );
      } catch (e) {
        emit(ProfileFailure(errorMessage: "حدث خطأ: ${e.toString()}"));
      }
    }
  }

  Future<void> logout() async {
    // إلغاء الاشتراك لمنع تحديثات لاحقة
    await _userSubscription?.cancel();

    // مسح آخر فرع مختار من SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('last_branch_id');

    // تسجيل الخروج من Firebase
    await FirebaseAuth.instance.signOut();

    // إرسال حالة نجاح الخروج
    emit(ProfileSuccess(message: "تم الخروج من التطبيق"));
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
