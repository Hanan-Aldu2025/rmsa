part of 'signup_cubit.dart';

@immutable
abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccese extends SignupState {
  final UserEntity userEntity;
  SignupSuccese({required this.userEntity});
}

class SignupOtpSent extends SignupState {
  // لتظهر للمستخدم أي رقم استلم الرسالة
  // SignupOtpSent({required this.phoneNumber});
}

class SignupFailure extends SignupState {
  final String message;
  SignupFailure({required this.message});
}

// ✅ حالة جديدة إذا البريد غير مفعل
class SignupEmailAlreadyExists extends SignupState {
  final UserEntity? userEntity;
  final String? message;

  SignupEmailAlreadyExists({this.userEntity, this.message});
}

class SignupEmailNotVerified extends SignupState {
  final UserEntity? userEntity; // لاحظ علامة ? لتسمح بـ null
  final String? message;

  SignupEmailNotVerified({this.userEntity, this.message});
}
