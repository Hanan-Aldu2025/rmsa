import 'package:appp/featurees/main_screens/offers_screen/data/model/offer_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OfferRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // للحصول على جميع العروض
  Future<List<OfferModel>> getOffers() async {
    try {
      final querySnapshot = await _firestore.collection('offers').get();
      return querySnapshot.docs
          .map((doc) => OfferModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to load offers: $e');
    }
  }

  // لإضافة عرض جديد
  Future<void> addOffer(OfferModel offer) async {
    try {
      await _firestore.collection('offers').add(offer.toMap());
      print('Offer added successfully');
    } catch (e) {
      throw Exception('Failed to add offer: $e');
    }
  }
}