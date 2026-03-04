// lib/featurees/main_screens/favorite/data/models/favorite_model.dart
import 'package:appp/featurees/main_screens/favorite/domain/entities/favorite_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// موديل المفضلة - مسؤول عن تحويل البيانات من وإلى Firestore
class FavoriteModel extends FavoriteEntity {
  const FavoriteModel({
    required super.id,
    required super.productId,
    required super.addedAt,
  });

  /// تحويل من DocumentSnapshot إلى Model
  factory FavoriteModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FavoriteModel(
      id: doc.id,
      productId: data['productId'] ?? '',
      addedAt: (data['addedAt'] as Timestamp).toDate(),
    );
  }

  /// تحويل من Model إلى Entity (هنا نفس الكلاس لأننا ورثنا)
  FavoriteEntity toEntity() {
    return this; // FavoriteModel يرث من FavoriteEntity
  }

  /// تحويل إلى Map للتخزين في Firestore
  Map<String, dynamic> toMap() {
    return {'productId': productId, 'addedAt': Timestamp.fromDate(addedAt)};
  }
}
