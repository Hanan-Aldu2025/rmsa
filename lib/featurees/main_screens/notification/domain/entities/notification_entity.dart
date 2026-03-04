// lib/featurees/main_screens/notifications/domain/entities/notification_entity.dart

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
