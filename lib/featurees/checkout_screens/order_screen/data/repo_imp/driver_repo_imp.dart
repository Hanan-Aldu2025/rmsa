import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/driver_model.dart';
class DriverRepository {
  final FirebaseFirestore firestore;

  DriverRepository(this.firestore);

  Future<DriverModel?> getAvailableDriver() async {
    try {
      final querySnapshot = await firestore
          .collection('drivers')
          .where('isAvailable', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final driverDoc = querySnapshot.docs.first;
      return DriverModel.fromMap(driverDoc.data(), driverDoc.id);
    } catch (e) {
      print("Error fetching available driver: $e");
      return null;
    }
  }

  Future<void> contactDriverWhatsApp(String phoneNumber, {String message = ""}) async {
    final Uri whatsappUri = Uri.parse("https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");

    if (!await launchUrl(whatsappUri, mode: LaunchMode.externalApplication)) {
      throw "تعذر فتح واتساب";
    }
  }

  /// دالة لإرسال تقييم السائق
  Future<void> submitDriverReview({
    required String driverId,
    required String orderId,
    required String userId,
    required int rating, // من 1 إلى 5
    String? comment,
  }) async {
    if (rating < 1 || rating > 5) {
      throw Exception("Rating must be between 1 and 5");
    }

    final reviewsCollection = firestore.collection('driver_reviews');

    // تحقق من عدم وجود تقييم سابق
    final existingQuery = await reviewsCollection
        .where('driverId', isEqualTo: driverId)
        .where('orderId', isEqualTo: orderId)
        .where('userId', isEqualTo: userId)
        .get();

    if (existingQuery.docs.isNotEmpty) {
      throw Exception("لقد قمت بتقييم هذا السائق مسبقًا لهذا الطلب");
    }

    // إنشاء التقييم الجديد
    await reviewsCollection.add({
      'driverId': driverId,
      'orderId': orderId,
      'userId': userId,
      'rating': rating,
      'comment': comment ?? '',
      'createdAt': Timestamp.now(),
    });

    print("✅ Review submitted for driver $driverId, order $orderId");

    // تحديث متوسط التقييمات
    final allReviewsQuery =
        await reviewsCollection.where('driverId', isEqualTo: driverId).get();

    if (allReviewsQuery.docs.isNotEmpty) {
      final ratings = allReviewsQuery.docs
          .map((doc) => (doc['rating'] as num).toDouble())
          .toList();
      final avgRating =
          ratings.reduce((a, b) => a + b) / ratings.length;

      await firestore.collection('drivers').doc(driverId).update({
        'rating': avgRating,
      });

      print("⭐ Driver $driverId new average rating: $avgRating");
    }
  }
}