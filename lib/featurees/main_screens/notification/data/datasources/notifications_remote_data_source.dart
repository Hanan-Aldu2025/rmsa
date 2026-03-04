// lib/featurees/main_screens/notifications/data/datasources/notifications_remote_data_source.dart

import 'package:appp/featurees/main_screens/notification/data/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// مصدر البيانات البعيد - مسؤول عن التواصل المباشر مع Firebase
class NotificationsRemoteDataSource {
  final FirebaseFirestore firestore;

  NotificationsRemoteDataSource({FirebaseFirestore? firestoreInstance})
    : firestore = firestoreInstance ?? FirebaseFirestore.instance;

  /// الاستماع لتحديثات الإشعارات
  Stream<List<NotificationModel>> watchNotifications(String uid) {
    return firestore
        .collection('user_information')
        .doc(uid)
        .collection('notifications')
        .orderBy('receivedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromDoc(doc))
              .toList(),
        );
  }

  /// حذف إشعار
  Future<void> deleteNotification({
    required String uid,
    required String notificationId,
  }) async {
    await firestore
        .collection('user_information')
        .doc(uid)
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }

  /// تحديث حالة الإشعار إلى مقروء
  Future<void> markAsRead({
    required String uid,
    required String notificationId,
  }) async {
    await firestore
        .collection('user_information')
        .doc(uid)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  /// تحديث حالة جميع الإشعارات إلى مقروءة
  Future<void> markAllAsRead(String uid) async {
    final batch = firestore.batch();
    final snapshot = await firestore
        .collection('user_information')
        .doc(uid)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }
}
