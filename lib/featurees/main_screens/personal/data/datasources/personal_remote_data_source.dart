// lib/featurees/main_screens/personal/data/datasources/personal_remote_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// مصدر البيانات البعيد - مسؤول عن التواصل مع Firebase
/// Remote Data Source - responsible for Firebase communication
class PersonalRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  PersonalRemoteDataSource({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  /// إعادة التحقق من هوية المستخدم
  /// Re-authenticate user
  Future<void> reauthenticateUser(String email, String password) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final cred = EmailAuthProvider.credential(email: email, password: password);
    await user.reauthenticateWithCredential(cred);
  }

  /// تحديث بيانات المستخدم في Firestore
  /// Update user data in Firestore
  Future<void> updateUserData({
    required String uid,
    required String name,
    required String phone,
    required String email,
  }) async {
    final Map<String, dynamic> updateData = {};

    if (name.isNotEmpty) updateData['user_name'] = name;
    if (phone.isNotEmpty) updateData['phone'] = phone;
    if (email.isNotEmpty) updateData['user_email'] = email;

    if (updateData.isNotEmpty) {
      await _firestore
          .collection('user_information')
          .doc(uid)
          .update(updateData);
    }
  }

  /// تحديث البريد الإلكتروني في Firebase Auth
  /// Update email in Firebase Auth
  Future<void> updateEmail(String newEmail) async {
    final user = _auth.currentUser;
    if (user != null && newEmail.isNotEmpty && newEmail != user.email) {
      await user.verifyBeforeUpdateEmail(newEmail);
    }
  }

  /// تحديث كلمة المرور في Firebase Auth
  /// Update password in Firebase Auth
  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user != null && newPassword.isNotEmpty) {
      await user.updatePassword(newPassword);
    }
  }
}
