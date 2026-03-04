// lib/featurees/main_screens/complaint/data/datasources/complaint_remote_data_source.dart

import 'package:cloud_firestore/cloud_firestore.dart';

/// مصدر البيانات البعيد - مسؤول عن التواصل المباشر مع Firebase
class ComplaintRemoteDataSource {
  final FirebaseFirestore firestore;

  ComplaintRemoteDataSource({FirebaseFirestore? firestoreInstance})
    : firestore = firestoreInstance ?? FirebaseFirestore.instance;

  /// إرسال شكوى إلى Firestore
  Future<void> submitComplaint({
    required String userId,
    required String email,
    required String complaintText,
  }) async {
    await firestore.collection('complaints').add({
      'userId': userId,
      'email': email,
      'complaintText': complaintText,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'pending',
    });
  }
}
