// lib/featurees/main_screens/profile/data/models/user_model.dart
import 'package:appp/featurees/main_screens/profile/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// موديل المستخدم - مسؤول عن تحويل البيانات من وإلى Firestore
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String profileImage;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profileImage,
  });

  /// تحويل من DocumentSnapshot إلى Model
  factory UserModel.fromDoc(DocumentSnapshot doc, String uid) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: uid,
      name: data['user_name'] ?? '',
      email: data['user_email'] ?? '',
      profileImage: data['profile_image'] ?? '',
    );
  }

  /// تحويل من Model إلى Entity
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      name: name,
      email: email,
      profileImage: profileImage,
    );
  }

  /// تحويل إلى Map للتخزين في Firestore
  Map<String, dynamic> toMap() {
    return {
      'user_name': name,
      'user_email': email,
      'profile_image': profileImage,
    };
  }
}
