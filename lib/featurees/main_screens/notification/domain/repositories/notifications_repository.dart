// lib/featurees/main_screens/notifications/domain/repositories/notifications_repository.dart

import 'package:appp/core/error/failure.dart';
import 'package:appp/featurees/main_screens/notification/domain/entities/notification_entity.dart';
import 'package:dartz/dartz.dart';

/// واجهة Notifications Repository - تحدد العقود التي يجب تنفيذها
abstract class NotificationsRepository {
  /// الاستماع لتحديثات الإشعارات المباشرة
  Stream<List<NotificationEntity>> watchNotifications(String uid);

  /// حذف إشعار معين
  Future<Either<Failure, void>> deleteNotification({
    required String uid,
    required String notificationId,
  });

  /// تحديث حالة الإشعار إلى مقروء
  Future<Either<Failure, void>> markAsRead({
    required String uid,
    required String notificationId,
  });

  /// تحديث حالة جميع الإشعارات إلى مقروءة
  Future<Either<Failure, void>> markAllAsRead(String uid);
}
