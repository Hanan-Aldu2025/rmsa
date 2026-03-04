// lib/featurees/main_screens/profile/domain/entities/user_entity.dart
import 'package:equatable/equatable.dart';

/// كيان المستخدم - يمثل بيانات المستخدم في طبقة التطبيق
class UserEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String profileImage;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.profileImage,
  });

  @override
  List<Object?> get props => [uid, name, email, profileImage];
}
