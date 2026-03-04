import 'package:appp/featurees/Auth/domain/entity/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.name,
    required super.email,
    required super.uId,
    required super.phoneNumber,
    required super.emailVerified,
  });

  // ✅ هنا نضيف named parameter phoneNumber بشكل رسمي
  factory UserModel.fromFirebaseUser(User user, {String phoneNumber = ""}) {
    return UserModel(
      name: user.displayName ?? '',
      email: user.email ?? '',
      uId: user.uid,
      phoneNumber: phoneNumber, // <- هنا يتعرف عليه
      emailVerified: user.emailVerified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_name": name,
      "user_email": email,
      "user_id": uId,
      "phone_number": phoneNumber,
      "email_verified": emailVerified,
    };
  }
}
