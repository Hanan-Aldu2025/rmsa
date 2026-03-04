// lib/featurees/main_screens/location/data/datasources/location_remote_data_source.dart

import 'package:appp/featurees/main_screens/home/presentation/views/data_layer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// مصدر البيانات البعيد - مسؤول عن التواصل المباشر مع Firebase
class LocationRemoteDataSource {
  final FirebaseFirestore firestore;

  LocationRemoteDataSource({FirebaseFirestore? firestoreInstance})
    : firestore = firestoreInstance ?? FirebaseFirestore.instance;

  /// جلب جميع الفروع من Firestore
  Future<List<BranchModel>> getAllBranches() async {
    try {
      final QuerySnapshot snapshot = await firestore
          .collection('branches')
          .orderBy('name')
          .get();

      return snapshot.docs.map((doc) => BranchModel.fromDoc(doc)).toList();
    } on FirebaseException catch (e) {
      throw Exception("فشل الاتصال بقاعدة البيانات: ${e.message}");
    } catch (e) {
      throw Exception("حدث خطأ غير متوقع: $e");
    }
  }
}
