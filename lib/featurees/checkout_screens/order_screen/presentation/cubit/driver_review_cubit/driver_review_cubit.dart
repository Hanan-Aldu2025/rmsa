import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'driver_review_state.dart';

class DriverReviewCubit extends Cubit<DriverReviewState> {
  DriverReviewCubit() : super(DriverReviewInitial());

  /// دالة إرسال التقييم
  Future<void> submitRating({
    required String driverId,
    required String orderId,
    required String userId,
    required double rating,
  }) async {
    emit(DriverReviewLoading());
    try {
      final reviewRef = FirebaseFirestore.instance.collection('driver_reviews').doc();

      // 1️⃣ إضافة التقييم
      await reviewRef.set({
        "driverId": driverId,
        "orderId": orderId,
        "userId": userId,
        "rating": rating,
        "createdAt": FieldValue.serverTimestamp(),
      });

      // 2️⃣ تحديث متوسط تقييم السائق
      final driverRef = FirebaseFirestore.instance.collection('drivers').doc(driverId);
      final driverSnap = await driverRef.get();

      final oldRating = (driverSnap['rating'] as num).toDouble();
      final totalRatings = driverSnap['totalRatings'] as int;
      final newRating = ((oldRating * totalRatings) + rating) / (totalRatings + 1);

      await driverRef.update({
        "rating": newRating,
        "totalRatings": totalRatings + 1,
      });

      emit(DriverReviewSuccess());
    } catch (e) {
      emit(DriverReviewError(e.toString()));
    }
  }
}