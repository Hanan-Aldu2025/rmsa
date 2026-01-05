import 'package:appp/featurees/Auth/domain/entity/user_entity.dart';

class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final UserEntity userEntity;
  final bool shouldResetFields;

  LoginSuccess({required this.userEntity, this.shouldResetFields = false});
}

final class LoginFailure extends LoginState {
  final String message;
  LoginFailure({required this.message});
}
