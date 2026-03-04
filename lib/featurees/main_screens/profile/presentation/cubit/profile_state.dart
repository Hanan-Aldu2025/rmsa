import 'package:equatable/equatable.dart';
import 'package:appp/featurees/main_screens/profile/domain/entities/user_entity.dart';

/// حالات صفحة الملف الشخصي

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class ProfileInitial extends ProfileState {}

/// حالة التحميل
class ProfileLoading extends ProfileState {}

// حالة التحميل
class ProfileLoaded extends ProfileState {
  final UserEntity user;
  final bool isGuest;

  const ProfileLoaded({required this.user, required this.isGuest});
  @override
  List<Object?> get props => [user, isGuest];
}

// حالة النجاح
class ProfileSuccess extends ProfileState {
  final String message;
  const ProfileSuccess({required this.message});
  @override
  List<Object?> get props => [message];
}

/// حالة الفشل
class ProfileFailure extends ProfileState {
  final String errorMessage;
  const ProfileFailure({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

// abstract class ProfileState extends Equatable {
//   const ProfileState();

//   @override
//   List<Object?> get props => [];
// }

// /// الحالة الأولية
// class ProfileInitial extends ProfileState {}

// /// حالة التحميل
// class ProfileLoading extends ProfileState {}

// /// حالة النجاح
// class ProfileSuccess extends ProfileState {
//   final String message;

//   const ProfileSuccess({required this.message});

//   @override
//   List<Object?> get props => [message];
// }

// /// حالة الفشل
// class ProfileFailure extends ProfileState {
//   final String errorMessage;

//   const ProfileFailure({required this.errorMessage});

//   @override
//   List<Object?> get props => [errorMessage];
// }
