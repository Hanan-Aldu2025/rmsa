// lib/featurees/main_screens/notifications/data/models/notification_model.dart

import 'package:appp/core/error/failure.dart';
import 'package:appp/featurees/main_screens/notification/presentation/views/notification_domain_layer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

/// موديل الإشعار - مسؤول عن تحويل البيانات من وإلى Firestore
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    this.isRead = false,
  });

  /// تحويل من DocumentSnapshot إلى Model
  factory NotificationModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      receivedAt:
          (data['receivedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
    );
  }

  /// تحويل من Model إلى Entity
  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      body: body,
      receivedAt: receivedAt,
      isRead: isRead,
    );
  }

  /// تحويل إلى Map للتخزين في Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'receivedAt': Timestamp.fromDate(receivedAt),
      'isRead': isRead,
    };
  }
}

// lib/featurees/main_screens/notifications/data/datasources/notifications_remote_data_source.dart

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

// lib/featurees/main_screens/notifications/data/repositories/notifications_repository_impl.dart

/// تنفيذ NotificationsRepository
class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<NotificationEntity>> watchNotifications(String uid) {
    return remoteDataSource
        .watchNotifications(uid)
        .map((models) => models.map((model) => model.toEntity()).toList());
  }

  @override
  Future<Either<Failure, void>> deleteNotification({
    required String uid,
    required String notificationId,
  }) async {
    try {
      await remoteDataSource.deleteNotification(
        uid: uid,
        notificationId: notificationId,
      );
      return const Right(null);
    } catch (e) {
      return Left(FailureServer('Error deleting notification: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead({
    required String uid,
    required String notificationId,
  }) async {
    try {
      await remoteDataSource.markAsRead(
        uid: uid,
        notificationId: notificationId,
      );
      return const Right(null);
    } catch (e) {
      return Left(FailureServer('Error marking as read: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead(String uid) async {
    try {
      await remoteDataSource.markAllAsRead(uid);
      return const Right(null);
    } catch (e) {
      return Left(FailureServer('Error marking all as read: $e'));
    }
  }
}
