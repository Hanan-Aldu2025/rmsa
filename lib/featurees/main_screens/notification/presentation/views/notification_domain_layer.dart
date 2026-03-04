// lib/featurees/main_screens/notifications/domain/entities/notification_entity.dart

import 'package:appp/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// كيان الإشعار - يمثل بيانات الإشعار في طبقة التطبيق
class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;
  final bool isRead;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    this.isRead = false,
  });

  /// إنشاء نسخة محدثة من الإشعار
  NotificationEntity copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? receivedAt,
    bool? isRead,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      receivedAt: receivedAt ?? this.receivedAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [id, title, body, receivedAt, isRead];
}

// lib/featurees/main_screens/notifications/domain/repositories/notifications_repository.dart

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
