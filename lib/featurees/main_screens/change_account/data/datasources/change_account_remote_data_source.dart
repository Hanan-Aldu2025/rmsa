import 'package:cloud_firestore/cloud_firestore.dart';

/// مصدر البيانات البعيد - مسؤول عن التواصل مع Firebase
class ChangeAccountRemoteDataSource {
  final FirebaseFirestore firestore;

  ChangeAccountRemoteDataSource({FirebaseFirestore? firestoreInstance})
    : firestore = firestoreInstance ?? FirebaseFirestore.instance;

  /// جلب دور المستخدم من Firestore
  Future<String> getUserRole(String uid) async {
    final doc = await firestore.collection('user_information').doc(uid).get();

    if (!doc.exists) {
      throw Exception('User not found');
    }

    final data = doc.data() as Map<String, dynamic>;
    return data['role'] ?? 'user';
  }
}
