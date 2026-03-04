// lib/featurees/main_screens/favorite/data/datasources/favorites_remote_data_source.dart

import 'package:appp/featurees/main_screens/favorite/data/models/favorite_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// مصدر البيانات البعيد - مسؤول عن التواصل المباشر مع Firebase
class FavoritesRemoteDataSource {
  final FirebaseFirestore firestore;

  FavoritesRemoteDataSource({FirebaseFirestore? firestoreInstance})
    : firestore = firestoreInstance ?? FirebaseFirestore.instance;

  /// جلب قائمة المفضلة من Firestore
  Future<List<FavoriteModel>> getFavorites(String uid) async {
    final snap = await firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .get();

    return snap.docs.map((d) => FavoriteModel.fromDoc(d)).toList();
  }

  /// إضافة منتج إلى المفضلة
  Future<void> addFavorite(String uid, String productId) async {
    await firestore.collection('users').doc(uid).collection('favorites').add({
      'productId': productId,
      'addedAt': Timestamp.now(),
    });
  }

  /// حذف منتج من المفضلة
  Future<void> removeFavorite(String uid, String favId) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(favId)
        .delete();
  }
}
